# Editing and navigation.
alias zcfg='$EDITOR "$ZSH_CONFIG_DIR"'
alias gozsh='zcfg'
alias gobash='gozsh'
alias hyprcfg='$EDITOR "${XDG_CONFIG_HOME:-$HOME/.config}/hypr"'
alias govim='$EDITOR "$HOME/.vimrc"'
alias nv='nvim'
alias nivm='nvim'
alias hx='helix'
alias nv.='nvim .'

# Development.
alias cg='cargo'
alias rqr='rust-quick-run.sh'
alias vm='quickemu --vm *.conf'
alias cl='clang-format -i -- *.c *.cpp *.h'
alias cmp='gcc -std=c99 -pedantic -Werror -Wall -Wextra -Wvla -g -fsanitize=address'
alias vmp='gcc -std=c99 -pedantic -Werror -Wall -Wextra -Wvla -g'
alias cppmp='g++ -Wall -Wextra -Werror -pedantic -std=c++20 -Wold-style-cast -fsanitize=address -g'
alias configure-flags='./configure CFLAGS="-std=c99 -pedantic -Werror -Wall -Wextra -Wvla -O0 -g -fsanitize=address" LDFLAGS="-fsanitize=address"'

# Git.
alias gap='git add -A'
alias gcm='git commit -m'
alias gtma='git tag -ma'
alias gpft='git push --follow-tags'
alias gs='git switch'

# Desktop and utilities.
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias sshfs='sshfs -o follow_symlinks'
alias daudio='systemctl --user restart wireplumber'
alias wlc='wl-copy'
alias pacman='sudo pacman'
alias vencord-update='sh -c "$(curl -sS https://vencord.dev/install.sh)"'

(( $+commands[kitten] )) && alias icat='kitten icat'

# eza replacements; prefix with a backslash to bypass an alias (for example, \ls).
if (( $+commands[eza] )); then
  alias ls='eza --icons=automatic --tree --level=1 --follow-symlinks --no-quotes'
  alias lsa='ls -a'
  alias lsl='eza --icons=automatic --long --header --group -M'
  alias tree='ls --level=3'
fi

