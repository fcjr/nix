export LANG=en_US.UTF-8

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git wd zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # export JAVA_HOME=$(/usr/libexec/java_home -v 18)
    # export PATH="/usr/libexec:$PATH"
  ;;
  linux*)
    export PATH="/home/fcjr/.local/share/fnm:$PATH"

    if ! command -v wezterm &> /dev/null; then
        alias wezterm="flatpak run org.wezfurlong.wezterm"
    fi

    alias code="code --ozone-platform=wayland"
  ;;
esac

## Secrets
[[ ! -f ~/.secrets ]] || source ~/.secrets

## Go
export GOPRIVATE=*

## FNM (Node Manager)
eval "$(fnm env)"

## Auto FNM
autoload -U add-zsh-hook
# place default node version under $HOME/.node_version
load-nvmrc() {
  DEFAULT_NODE_VERSION=`cat $HOME/.node_version`
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    fnm use
  #elif [[ `node -v` != $DEFAULT_NODE_VERSION ]]; then
  #  echo Reverting to node from "`node -v`" to "$DEFAULT_NODE_VERSION"
  #  fnm use $DEFAULT_NODE_VERSION
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

## Brew Zsh Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

## The Fuck
eval $(thefuck --alias)

## Go Binaries
export PATH="$PATH:$HOME/go/bin"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f ~/git/proxmark3 ]] || export PATH=$PATH:~/git/proxmark3

# bun completions
[ ! -f "~/.bun/_bun" ] || source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# deno completions
if [[ ":$FPATH:" != *":/Users/fcjr/.zsh/completions:"* ]]; then export FPATH="/Users/fcjr/.zsh/completions:$FPATH"; fi

# deno
if [[ -f $HOME/.deno/env ]]; then
    source $HOME/.deno/env
fi

function colima-start() {
  colima start --mount-type 9p
}

alias vim=nvim

eval "$(zoxide init zsh)"
alias cd=z

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:$HOME/flutter/bin"
eval "$(rbenv init - zsh)"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
