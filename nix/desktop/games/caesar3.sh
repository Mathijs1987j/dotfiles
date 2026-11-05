# GENERATED from config.org ("Games / Caesar III"). Do not edit; edit config.org.
# caesar3: Caesar III through Augustus. The first start unpacks the game
# files from GOG's installer into ~/.local/share/caesar3, where Augustus
# also keeps your saved games.
data="${XDG_DATA_HOME:-$HOME/.local/share}/caesar3"

if [ ! -e "$data/.installed" ]; then
  setup=$(find_one "$installer" "GOG's offline installer for Caesar III")
  check_sum "$setup" "$sha256"
  tmp=$(mktemp -d)
  echo "Unpacking $(basename "$setup") ..."
  innoextract --silent --output-dir "$tmp" "$setup"
  marker=$(find "$tmp" -iname 'c3.eng' -print -quit)
  if [ -z "$marker" ]; then
    rm -rf "$tmp"
    echo "No Caesar III game files (c3.eng) found in the installer." >&2
    exit 1
  fi
  mkdir -p "$data"
  cp -R --no-preserve=mode "$(dirname "$marker")"/. "$data"/
  rm -rf "$tmp"
  touch "$data/.installed"
fi

# Scale and pointer size from live/caesar3/caesar3.conf, read at every start.
display_scale=""
cursor_scale=""
conf="${XDG_CONFIG_HOME:-$HOME/.config}/caesar3/caesar3.conf"
if [ -f "$conf" ]; then
  # shellcheck source=/dev/null
  . "$conf"
fi
args=()
if [ -n "$display_scale" ]; then
  args+=(--display-scale "$display_scale")
fi
if [ -n "$cursor_scale" ]; then
  args+=(--cursor-scale "$cursor_scale")
fi

exec augustus "${args[@]}" "$data"
