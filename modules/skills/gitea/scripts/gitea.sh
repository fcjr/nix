#!/bin/sh
# Gitea PR helper. Host + owner/repo are derived from the git remote of the
# current repo; the API token comes from the macOS login Keychain (or $GITEA_TOKEN).
#
# Usage:
#   gitea.sh get <num>                         # title/state/branches/body
#   gitea.sh current                           # PR number open for the current branch
#   gitea.sh list                              # open PRs (num, branches, author, title)
#   gitea.sh create [--push] <base> "<title>" <body-file>   # open a PR from the current branch
#   gitea.sh edit <num> "<title>" <body-file>  # update title + body (title "" keeps it)
#   gitea.sh status <num>                       # mergeable + CI status for the head commit
#   gitea.sh diff <num>                         # raw unified diff
#   gitea.sh files <num>                        # changed files (with status)
#   gitea.sh comments <num>                     # read the conversation
#   gitea.sh comment <num> <body-file>          # add a comment
#   gitea.sh merge <num> <squash|rebase|merge>  # merge the PR
#
# Token: stored as a generic-password (service name "gitea-token" by default):
#   security add-generic-password -U -a "$USER" -s gitea-token -w
# Overrides: $GITEA_TOKEN (use directly), $GITEA_TOKEN_SERVICE (Keychain service),
#            $GITEA_REMOTE (git remote, default origin).
set -eu

TOKEN_SERVICE="${GITEA_TOKEN_SERVICE:-gitea-token}"

token() {
    if [ -n "${GITEA_TOKEN:-}" ]; then printf '%s' "$GITEA_TOKEN"; return; fi
    security find-generic-password -a "$USER" -s "$TOKEN_SERVICE" -w 2>/dev/null || {
        echo "no Gitea token in the Keychain (service '$TOKEN_SERVICE'). Add one with:" >&2
        echo "  security add-generic-password -U -a \"\$USER\" -s $TOKEN_SERVICE -w" >&2
        exit 1
    }
}

remote_url() { git remote get-url "${GITEA_REMOTE:-origin}"; }

host() {
    u="$(remote_url)"
    case "$u" in
        git@*) printf '%s' "${u#git@}" | cut -d: -f1 ;;
        http*://*) printf '%s' "$u" | sed -E 's#^https?://##; s#^[^@]*@##; s#/.*##' ;;
        *) echo "unsupported remote URL: $u" >&2; exit 1 ;;
    esac
}

ownerrepo() {
    u="$(remote_url)"
    case "$u" in
        git@*) printf '%s' "${u#*:}" | sed 's#\.git$##' ;;
        http*://*) printf '%s' "$u" | sed -E 's#^https?://[^/]+/##; s#\.git$##' ;;
    esac
}

api() { # METHOD PATH [JSON_FILE]
    _m="$1"; _p="$2"; _f="${3:-}"
    if [ -n "$_f" ]; then
        curl -fsSL -X "$_m" -H "Authorization: token $TOKEN" \
            -H "Content-Type: application/json" --data-binary @"$_f" "$BASE$_p"
    else
        curl -fsSL -X "$_m" -H "Authorization: token $TOKEN" "$BASE$_p"
    fi
}

# Build a JSON object from KEY=VALUE pairs; a key suffixed with @ reads its value
# from the named file. e.g. json title="Fix" body@=/tmp/b.md head=feature
json() {
    python3 - "$@" <<'PY'
import json, sys
o = {}
for arg in sys.argv[1:]:
    k, _, v = arg.partition("=")
    if k.endswith("@"):
        with open(v) as f: o[k[:-1]] = f.read()
    else:
        o[k] = v
json.dump(o, sys.stdout)
PY
}

cmd="${1:-}"
[ "$#" -gt 0 ] && shift

case "$cmd" in
    get | current | list | create | edit | status | diff | files | comments | comment | review | reviews | merge)
        TOKEN="$(token)"
        BASE="https://$(host)/api/v1/repos/$(ownerrepo)"
        ;;
esac

case "$cmd" in
    get)
        api GET "/pulls/$1" | python3 -c 'import sys,json
d=json.load(sys.stdin)
print("TITLE:",d["title"]); print("STATE:",d["state"])
print("BRANCHES:",d["head"]["ref"],"->",d["base"]["ref"])
print("URL:",d.get("html_url","")); print("---"); print(d["body"])'
        ;;
    current)
        br="$(git rev-parse --abbrev-ref HEAD)"
        api GET "/pulls?state=open&limit=50" | BR="$br" python3 -c 'import sys,json,os
m=[p for p in json.load(sys.stdin) if p["head"]["ref"]==os.environ["BR"]]
print(m[0]["number"] if m else "")'
        ;;
    list)
        api GET "/pulls?state=open&limit=50" | python3 -c 'import sys,json
for p in json.load(sys.stdin):
    print("#%s  %s -> %s  @%s  %s" % (p["number"], p["head"]["ref"], p["base"]["ref"], p["user"]["login"], p["title"]))'
        ;;
    create)
        push=0
        if [ "${1:-}" = "--push" ]; then push=1; shift; fi
        base="$1"; title="$2"; bodyfile="${3:-}"
        head="$(git rev-parse --abbrev-ref HEAD)"
        [ "$push" -eq 1 ] && git push -u "${GITEA_REMOTE:-origin}" "$head" >&2
        if [ -n "$bodyfile" ]; then
            json "head=$head" "base=$base" "title=$title" "body@=$bodyfile" > /tmp/gitea-payload.json
        else
            json "head=$head" "base=$base" "title=$title" > /tmp/gitea-payload.json
        fi
        api POST "/pulls" /tmp/gitea-payload.json | python3 -c 'import sys,json
d=json.load(sys.stdin); print("created PR #%s: %s" % (d["number"], d.get("html_url","")))'
        ;;
    edit)
        num="$1"; title="$2"; bodyfile="${3:-}"
        set --
        [ -n "$title" ] && set -- "$@" "title=$title"
        [ -n "$bodyfile" ] && set -- "$@" "body@=$bodyfile"
        json "$@" > /tmp/gitea-payload.json
        api PATCH "/pulls/$num" /tmp/gitea-payload.json >/dev/null && echo "edited PR #$num"
        ;;
    status)
        num="$1"
        pr="$(api GET "/pulls/$num")"
        sha="$(printf '%s' "$pr" | python3 -c 'import sys,json;print(json.load(sys.stdin)["head"]["sha"])')"
        printf '%s' "$pr" | python3 -c 'import sys,json
d=json.load(sys.stdin)
print("STATE:",d["state"],"| MERGEABLE:",d.get("mergeable"))'
        api GET "/commits/$sha/status" | python3 -c 'import sys,json
d=json.load(sys.stdin)
print("CI:",d.get("state","(none)"))
for s in d.get("statuses",[]):
    print("  -",s.get("status"),s.get("context"),s.get("target_url") or "")'
        ;;
    diff)
        api GET "/pulls/$1.diff"
        ;;
    files)
        api GET "/pulls/$1.diff" | python3 -c 'import sys,re
st={}
cur=None
for line in sys.stdin:
    m=re.match(r"^diff --git a/.* b/(.*)$",line)
    if m: cur=m.group(1); st[cur]="modified"; continue
    if cur:
        if line.startswith("new file"): st[cur]="added"
        elif line.startswith("deleted file"): st[cur]="deleted"
        elif line.startswith("rename "): st[cur]="renamed"
for f,s in st.items(): print(f"{s:9} {f}")'
        ;;
    comments)
        api GET "/issues/$1/comments" | python3 -c 'import sys,json
cs=json.load(sys.stdin)
if not cs: print("(no comments)")
for c in cs:
    print("@%s (%s):" % (c["user"]["login"], c["created_at"][:10]))
    print(c["body"]); print("---")'
        ;;
    comment)
        num="$1"; bodyfile="$2"
        json "body@=$bodyfile" > /tmp/gitea-comment.json
        api POST "/issues/$num/comments" /tmp/gitea-comment.json >/dev/null && echo "commented on PR #$num"
        ;;
    reviews)
        num="$1"
        rs="$(api GET "/pulls/$num/reviews")"
        printf '%s' "$rs" | python3 -c 'import sys,json
rs=json.load(sys.stdin)
if not rs: print("(no reviews)")'
        for rid in $(printf '%s' "$rs" | python3 -c 'import sys,json
for r in json.load(sys.stdin):
    if r.get("comments_count",0) or r.get("body"): print(r["id"])'); do
            api GET "/pulls/$num/reviews/$rid" | python3 -c 'import sys,json
r=json.load(sys.stdin)
print("REVIEW #%s by @%s [%s]" % (r["id"], r["user"]["login"], r.get("state","")))
if r.get("body"): print(r["body"])'
            api GET "/pulls/$num/reviews/$rid/comments" | python3 -c 'import sys,json
for c in json.load(sys.stdin):
    line=c.get("new_position") or c.get("original_position") or c.get("position") or "?"
    print("  %s:%s  @%s" % (c.get("path"), line, c["user"]["login"]))
    print("    " + c.get("body","").replace(chr(10), chr(10)+"    "))'
            echo "==="
        done
        ;;
    review)
        num="$1"; event="$2"; cfile="$3"; bodyfile="${4:-}"
        case "$event" in
            comment) ev=COMMENT ;;
            approve) ev=APPROVED ;;
            request-changes) ev=REQUEST_CHANGES ;;
            *) echo "event must be: comment | approve | request-changes" >&2; exit 2 ;;
        esac
        EV="$ev" CFILE="$cfile" BODYFILE="$bodyfile" python3 -c 'import sys,json,os
with open(os.environ["CFILE"]) as f: cs=json.load(f)
body=""
bf=os.environ.get("BODYFILE","")
if bf:
    with open(bf) as f: body=f.read()
out={"event":os.environ["EV"],"body":body,"comments":[]}
for c in cs:
    item={"path":c["path"],"body":c["body"]}
    if c.get("side")=="old": item["old_position"]=c["line"]
    else: item["new_position"]=c["line"]
    out["comments"].append(item)
json.dump(out,sys.stdout)' > /tmp/gitea-review.json
        api POST "/pulls/$num/reviews" /tmp/gitea-review.json | python3 -c 'import sys,json
d=json.load(sys.stdin)
print("posted review #%s [%s]" % (d.get("id"), d.get("state","")))'
        ;;
    merge)
        num="$1"; method="${2:-}"
        case "$method" in
            squash | rebase | merge) ;;
            *) echo "merge needs a method: squash | rebase | merge" >&2; exit 2 ;;
        esac
        json "Do=$method" > /tmp/gitea-merge.json
        api POST "/pulls/$num/merge" /tmp/gitea-merge.json >/dev/null && echo "merged PR #$num ($method)"
        ;;
    *)
        sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
        exit 2
        ;;
esac
