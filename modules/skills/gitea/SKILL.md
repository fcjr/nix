---
name: gitea
description: Interact with Gitea pull requests via the Gitea API — read/update/create/merge a PR, find the PR for the current branch, post or read comments, post a code review with inline comments, and pull a PR's feedback to address it. Use when the user asks to update a PR description, review the current branch / post inline review comments, address PR feedback, or otherwise work with PRs on a Gitea host (e.g. gitea.app.monadical.io). Authenticates with a token from the macOS login Keychain; derives host and owner/repo from the current git remote.
---

# Gitea PR helper

Operate on Gitea pull requests through the API. The Gitea API rejects anonymous
requests, and the git remote is typically SSH (no reusable HTTP token), so a
**personal access token from the macOS Keychain** is used for auth.

All operations go through the bundled script `scripts/gitea.sh`, which derives
the host and `owner/repo` from `git remote get-url origin` and reads the token
from the Keychain. **Run it from inside the target repo's working tree.**

## Prerequisites

- A Gitea token stored in the login Keychain (service `gitea-token`):
  ```sh
  security add-generic-password -U -a "$USER" -s gitea-token -w
  ```
  Scope it minimally (repo write / issue write), not full access. First read may
  pop a Keychain prompt — Always Allow.
- If no token is found, the script prints the exact `add-generic-password` command;
  surface that to the user rather than guessing.

## Commands

Run from the repo directory (`S=~/.claude/skills/gitea/scripts/gitea.sh`):

```sh
sh "$S" get <num>                         # title/state/branches/url/body
sh "$S" current                           # PR number open for the current branch
sh "$S" list                              # open PRs (num, branches, author, title)
sh "$S" create [--push] <base> "<title>" <body-file>   # open a PR from the current branch
sh "$S" edit <num> "<title>" <body-file>  # update title + body
sh "$S" status <num>                      # mergeable + CI status for the head commit
sh "$S" diff <num>                        # raw unified diff
sh "$S" files <num>                       # changed files (added/modified/deleted)
sh "$S" comments <num>                    # read the conversation (issue-level comments)
sh "$S" comment <num> <body-file>         # add a conversation comment
sh "$S" reviews <num>                      # read reviews + their inline comments
sh "$S" review <num> <comment|approve|request-changes> <comments-json> [body-file]   # post a review w/ inline comments
sh "$S" merge <num> <squash|rebase|merge> # merge the PR
```

- `<comments-json>` for `review` is a JSON array of inline comments:
  ```json
  [{"path": "rel/path.swift", "line": 70, "body": "..."},
   {"path": "rel/path.swift", "line": 40, "body": "...", "side": "old"}]
  ```
  `line` is the line number in the **new** file; add `"side": "old"` to comment on
  a removed line (then `line` is the old-file line). A line must fall inside a diff
  hunk or Gitea drops the comment.

- `create` opens a PR with the **current branch** as head; `--push` pushes it first.
- Pass `""` as the title to `edit` to keep the existing title and only change the body.
- `merge` requires an explicit method (no default) — confirm with the user before
  running it; it's irreversible.
- The body is always read from a **file** (not an arg) so multi-line markdown and
  shell metacharacters are handled cleanly. Write the drafted body to a temp file
  under the scratchpad dir first.
- A successful `edit` returns HTTP 201 (Gitea's convention) — the script prints
  `edited PR #<num>`.

## Typical workflow: update a PR description

1. Identify the PR: use the number the user gave, or `gitea.sh current` to find
   the open PR for the checked-out branch.
2. `gitea.sh get <num>` to read the existing title/body.
3. Draft the new body, write it to a temp file (scratchpad).
4. `gitea.sh edit <num> "<title>" <body-file>`.
5. `gitea.sh get <num>` to confirm it took.

## Workflow: review the current branch's PR (post inline comments)

1. `num=$(gitea.sh current)` — the open PR for the checked-out branch. If empty,
   there's no PR; tell the user (offer `create`). Don't guess a number.
2. `gitea.sh get <num>` for the base branch and context.
3. `gitea.sh diff <num>` — review **the PR's actual diff** (not just local `git
   diff`), so comment line numbers match what Gitea has.
4. Analyze the diff. For each finding, record the file path and the **new-file line
   number**: read each hunk header `@@ -old +newStart,newCount @@` and count added
   (`+`) and context (space) lines from `newStart`. Only lines inside a hunk can
   carry an inline comment. For a comment on a removed (`-`) line, use the old-file
   line number and `"side": "old"`.
5. Write the findings to a JSON array (scratchpad) per the `review` schema above,
   and optionally a summary body file.
6. Post: `gitea.sh review <num> <comment|request-changes|approve> <comments-json> [body-file]`.
   Default to `comment` unless the user asked to approve / request changes.
7. `gitea.sh reviews <num>` to confirm the comments landed (anything Gitea
   dropped for an out-of-hunk line won't appear — re-check those line numbers).

## Workflow: address PR feedback on the current branch

1. `num=$(gitea.sh current)`; bail if empty.
2. Pull **all** feedback — it can live in either place:
   - `gitea.sh comments <num>` — conversation (issue-level) comments.
   - `gitea.sh reviews <num>` — reviews + their inline (path:line) comments.
3. For each actionable item, find the referenced code (path:line from inline
   comments; search by quoted snippet otherwise) and make the fix with normal
   edits. Group the work; skip anything that's a question/non-actionable, and note
   why.
4. Build, test, and lint per the repo's conventions before considering it done.
5. Commit and push the branch (only when the user asks to push — see the global
   git rules). The PR updates automatically on push.
6. Optionally reply: `gitea.sh comment <num> <body-file>` summarizing what you
   changed per piece of feedback (reference each point). Confirm with the user
   before posting a reply.

## Writing PR text

PR titles and bodies are public on the repo — write them as a normal human
developer would, describing what the change does. Match the repo's existing PR
style. Follow any repo/user conventions already in effect.

## Overrides

- `GITEA_TOKEN` — use this token instead of the Keychain.
- `GITEA_TOKEN_SERVICE` — Keychain service name (default `gitea-token`).
- `GITEA_REMOTE` — git remote to derive host/repo from (default `origin`).
