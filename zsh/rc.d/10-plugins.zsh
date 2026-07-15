# Plugin manager and plugins that must load before completion initialization.

typeset -g ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  if (( $+commands[git] )); then
    mkdir -p "${ZINIT_HOME:h}"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  else
    print -u2 'zsh: cannot install zinit because git is unavailable'
  fi
fi

if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"

  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  # This plugin adds completion definitions and therefore precedes compinit.
  zinit light zsh-users/zsh-completions

  zinit snippet OMZP::git
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::sudo
fi

