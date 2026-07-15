# History and general shell behavior.

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_hist"

setopt append_history
setopt share_history
setopt hist_ignore_space
setopt correct

# Duplicate-removal options are intentionally disabled: every command is retained.
# setopt hist_ignore_all_dups hist_ignore_dups hist_find_no_dups

