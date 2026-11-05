# GENERATED from config.org ("Games / Civilization IV with BUG"). Do not edit; edit config.org.
# civ4: Civilization IV (Beyond the Sword) under Wine, with the BUG mod.
# The first start creates a 32-bit Wine prefix, adds msxml3 and d3dx9 and
# runs GOG's installer; BUG is installed whenever it is missing.
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine/civ4"
export WINEARCH=win32
export WINEDEBUG=fixme-all
export LC_ALL=C
game_windows='C:\GOG Games\Civilization IV Complete'

if [ ! -e "$WINEPREFIX/.installed" ]; then
  setup=$(find_one "$installer" "GOG's offline installer for Civilization IV (all its files)")
  check_sum "$setup" "$sha256"
  echo "Creating the Wine prefix, with msxml3 and d3dx9 (needs the internet) ..."
  mkdir -p "$(dirname "$WINEPREFIX")"
  # No Wine Mono (.NET) or Wine Gecko: the game needs neither, so don't ask.
  WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init
  winetricks -q isolate_home msxml3 d3dx9
  # Wine's standard DPI, as in the setup that worked (see "Resolution").
  wine reg add 'HKCU\Control Panel\Desktop' /v LogPixels /t REG_DWORD /d 96 /f
  echo "Running GOG's installer ..."
  wine "$setup" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR="$game_windows"
  wineserver --wait
  touch "$WINEPREFIX/.installed"
fi

# GOG's installer puts Beyond the Sword a folder deeper than you might expect
# (...\Civilization IV Complete\Civ4\Beyond the Sword): look for the program
# instead of assuming the layout.
exe=$(find "$WINEPREFIX/drive_c/GOG Games" -iname 'Civ4BeyondSword.exe' -print -quit)
if [ -z "$exe" ]; then
  echo "Civ4BeyondSword.exe not found in the Wine folder's GOG Games." >&2
  echo "To reinstall: delete $WINEPREFIX and start civ4 again." >&2
  exit 1
fi
bts=$(dirname "$exe")

my_games="$WINEPREFIX/drive_c/users/$USER/Documents/My Games/Beyond the Sword"
if [ ! -d "$my_games/BUG Mod" ]; then
  zip=$(find_one "$bug" "the BUG mod's zip from civ4bug.sourceforge.net")
  check_sum "$zip" "$bug_sha256"
  tmp=$(mktemp -d)
  unzip -q "$zip" -d "$tmp"
  # The zip is a mod folder (Assets, Info, UserSettings, PrivateMaps), at its
  # top or inside a folder of its own: find the folder that holds Assets.
  assets=$(find "$tmp" -maxdepth 2 -type d -name 'Assets' -print -quit)
  if [ -z "$assets" ]; then
    rm -rf "$tmp"
    echo "No Assets folder found in $(basename "$zip"); is it the BUG mod?" >&2
    exit 1
  fi
  root=$(dirname "$assets")
  # As BUG's readme describes: Assets into CustomAssets, Info and
  # UserSettings into "BUG Mod", the map scripts into the game's PublicMaps.
  mkdir -p "$my_games/CustomAssets" "$my_games/BUG Mod"
  cp -R --no-preserve=mode "$assets"/. "$my_games/CustomAssets"/
  for folder in Info UserSettings; do
    if [ -d "$root/$folder" ]; then
      cp -R --no-preserve=mode "$root/$folder" "$my_games/BUG Mod"/
    fi
  done
  if [ -d "$root/PrivateMaps" ] && [ -d "$bts/PublicMaps" ]; then
    cp -R --no-preserve=mode "$root/PrivateMaps"/. "$bts/PublicMaps"/
  fi
  rm -rf "$tmp"
  echo "BUG installed in My Games/Beyond the Sword (CustomAssets and BUG Mod)."
fi

# Resolution and fullscreen from live/civ4/civ4.conf, written into the game's
# own settings file at every start.
screen_width=""
screen_height=""
fullscreen=""
conf="${XDG_CONFIG_HOME:-$HOME/.config}/civ4/civ4.conf"
if [ -f "$conf" ]; then
  # shellcheck source=/dev/null
  . "$conf"
fi
ini="$my_games/CivilizationIV.ini"
if [ -f "$ini" ]; then
  # Only the number after "Key =" changes; the rest of each line (including
  # the Windows line ending) stays as it is.
  if [ -n "$screen_width" ]; then
    sed -i -E "s/^(ScreenWidth *= *)[0-9]+/\1$screen_width/" "$ini"
  fi
  if [ -n "$screen_height" ]; then
    sed -i -E "s/^(ScreenHeight *= *)[0-9]+/\1$screen_height/" "$ini"
  fi
  if [ -n "$fullscreen" ]; then
    sed -i -E "s/^(FullScreen *= *)[0-9]+/\1$fullscreen/" "$ini"
  fi
else
  echo "First start: the game creates its settings file now. The resolution"
  echo "from ~/.config/civ4/civ4.conf applies from the next start on."
fi

cd "$bts"
exec wine Civ4BeyondSword.exe "$@"
