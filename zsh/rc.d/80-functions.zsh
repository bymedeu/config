# Small shell helpers and larger functions kept in separate files.

function pprof() {
  command cat /sys/firmware/acpi/platform_profile
}

function pprof-list() {
  command cat /sys/firmware/acpi/platform_profile_choices
}

function battery() {
  local -a batteries=(/sys/class/power_supply/BAT*(N))
  (( ${#batteries} )) || { print -u2 'No battery found'; return 1; }
  command cat "$batteries[1]/capacity"
}

function power-draw() {
  local -a batteries=(/sys/class/power_supply/BAT*(N))
  (( ${#batteries} )) || { print -u2 'No battery found'; return 1; }

  local current_file="$batteries[1]/current_now"
  local voltage_file="$batteries[1]/voltage_now"
  [[ -r "$current_file" && -r "$voltage_file" ]] || {
    print -u2 'Battery power data is unavailable'
    return 1
  }

  local current="$(<"$current_file")"
  local voltage="$(<"$voltage_file")"
  printf '%.2f W\n' "$(( current * voltage / 1.0e12 ))"
}

[[ -r "$ZSH_CONFIG_DIR/git-tools.zsh" ]] && source "$ZSH_CONFIG_DIR/git-tools.zsh"

