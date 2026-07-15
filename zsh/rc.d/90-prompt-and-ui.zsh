# Prompt configuration and plugins that should wrap ZLE widgets last.

[[ -r "$ZSH_CONFIG_DIR/p10k.zsh" ]] && source "$ZSH_CONFIG_DIR/p10k.zsh"

if (( $+functions[zinit] )); then
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
fi

