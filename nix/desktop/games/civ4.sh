# GENERATED from config.org ("Games / Civilization IV with BUG"). Do not edit; edit config.org.
# civ4: Civilization IV (Beyond the Sword) under Wine, with the BUG mod.
# The first start creates a 32-bit Wine prefix, adds msxml3 and d3dx9 and
# runs GOG's installer; BUG is installed whenever it is missing.
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine/civ4"
export WINEARCH=win32
export WINEDEBUG=-all
export LC_ALL=C
game_windows='C:\GOG Games\Civilization IV Complete'
game="$WINEPREFIX/drive_c/GOG Games/Civilization IV Complete"

if [ ! -e "$WINEPREFIX/.installed" ]; then
  setup=$(find_one "$installer" "GOG's offline installer for Civilization IV (all its files)")
  check_sum "$setup" "$sha256"
  echo "Creating the Wine prefix, with msxml3 and d3dx9 (needs the internet) ..."
  mkdir -p "$(dirname "$WINEPREFIX")"
  wineboot --init
  winetricks -q sandbox msxml3 d3dx9
  echo "Running GOG's installer ..."
  wine "$setup" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR="$game_windows"
  wineserver --wait
  touch "$WINEPREFIX/.installed"
fi

my_games="$WINEPREFIX/drive_c/users/$USER/Documents/My Games/Beyond the Sword"
if [ ! -d "$my_games/CustomAssets" ]; then
  zip=$(find_one "$bug" "the BUG mod's zip from civ4bug.sourceforge.net")
  check_sum "$zip" "$bug_sha256"
  tmp=$(mktemp -d)
  unzip -q "$zip" -d "$tmp"
  # The zip may hold CustomAssets at the top or inside a folder of its own:
  # what goes into "Beyond the Sword" is the folder that contains it.
  assets=$(find "$tmp" -type d -iname 'CustomAssets' -print -quit)
  if [ -z "$assets" ]; then
    rm -rf "$tmp"
    echo "No CustomAssets folder found in $(basename "$zip"); is it the BUG mod?" >&2
    exit 1
  fi
  mkdir -p "$my_games"
  cp -R --no-preserve=mode "$(dirname "$assets")"/. "$my_games"/
  rm -rf "$tmp"
  echo "BUG installed in My Games/Beyond the Sword."
fi

cd "$game/Beyond the Sword"
exec wine Civ4BeyondSword.exe "$@"
