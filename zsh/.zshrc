# Main zsh entrypoint. ~/.zshrc sources this file.

# Powerlevel10k instant prompt must stay before anything that may print or prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Public configuration is split by concern and loaded in numeric order.
for zsh_config_file in "$ZSH_CONFIG_DIR"/rc.d/*.zsh(N); do
  source "$zsh_config_file"
done

# Private files are optional and ignored by Git. Split them however you like:
# private_work.zsh, private_tokens.zsh, private_machine.zsh, etc.
for zsh_config_file in "$ZSH_CONFIG_DIR"/private_*.zsh(N); do
  source "$zsh_config_file"
done

unset zsh_config_file

