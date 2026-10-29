# GENERATED from config.org ("Games"). Do not edit; edit config.org.
# Shared by the game launchers. $installers is set by Nix before this text.

# find_one PATTERN WHAT: the single file in $installers matching PATTERN.
find_one() {
  local matches
  shopt -s nullglob
  # shellcheck disable=SC2206 # the pattern must expand here
  matches=("$installers"/$1)
  shopt -u nullglob
  if [ "${#matches[@]}" -ne 1 ]; then
    echo "Expected one file matching '$1' in $installers, found ${#matches[@]}." >&2
    echo "Put $2 there (see Games in config.org), then start the game again." >&2
    exit 1
  fi
  printf '%s\n' "${matches[0]}"
}

# check_sum FILE EXPECTED: compare FILE with the checksum from config.org.
check_sum() {
  local actual
  actual=$(sha256sum "$1" | cut -d' ' -f1)
  if [ -z "$2" ]; then
    echo "Checksum of $(basename "$1"): $actual"
    echo "(put it in config.org, Games, to pin exactly this file)"
  elif [ "$actual" != "$2" ]; then
    echo "$(basename "$1") does not match its checksum in config.org; stopping." >&2
    exit 1
  fi
}
