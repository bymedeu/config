# Optional command-line tool integrations.

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd cd zsh)"
fi

if (( $+commands[pyenv] )); then
  eval "$(pyenv init - --no-rehash zsh)"
fi
