# Emacs-style line editing and terminal key sequences.

bindkey -e
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

