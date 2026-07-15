# Completion initialization and presentation.

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always "$realpath" 2>/dev/null || command ls --color=always "$realpath"'

# fzf-tab must be loaded after compinit and before plugins that wrap ZLE widgets.
if (( $+functions[zinit] )); then
  zinit light Aloxaf/fzf-tab
  zinit cdreplay -q
fi

