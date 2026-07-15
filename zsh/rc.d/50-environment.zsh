# Public, portable environment variables and PATH entries.

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"

# zsh keeps $path and $PATH synchronized. -U removes duplicate entries.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$path[@]"
)

export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
path=("$PNPM_HOME" "$path[@]")

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" "$path[@]")
