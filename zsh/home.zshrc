# Keep this file minimal. The versioned configuration lives under ~/.config/zsh.
typeset zsh_config_home="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"

if [[ -r "$zsh_config_home" ]]; then
  source "$zsh_config_home"
else
  print -u2 "zsh: configuration not found: $zsh_config_home"
fi

unset zsh_config_home

