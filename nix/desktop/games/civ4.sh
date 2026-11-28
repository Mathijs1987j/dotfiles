# GENERATED from config.org ("Games / Civilization IV with BUG"). Do not edit; edit config.org.
# civ4: Civilization IV (Beyond the Sword) under Wine, with the BUG mod.
# The first start creates a 32-bit Wine prefix, adds msxml3 and d3dx9 and
# runs GOG's installer; BUG is installed whenever it is missing.
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine/civ4"
export WINEARCH=win32
export WINEDEBUG=fixme-all
export LC_ALL=C
# No menu entries from Wine (see "No menu entries from Wine").
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
# Don't wait for the screen's refresh: no hangs after switching windows
# (see "Switching windows").
export vblank_mode=0
game_windows='C:\GOG Games\Civilization IV Complete'

if [ ! -e "$WINEPREFIX/.installed" ]; then
  setup=$(find_one "$installer" "GOG's offline installer for Civilization IV (all its files)")
  check_sum "$setup" "$sha256"
  echo "Creating the Wine prefix, with msxml3 and d3dx9 (needs the internet) ..."
  mkdir -p "$(dirname "$WINEPREFIX")"
  # No Wine Mono (.NET) or Wine Gecko: the game needs neither, so don't ask.
  WINEDLLOVERRIDES="mscoree,mshtml=;winemenubuilder.exe=d" wineboot --init
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

# The game's icon for its fuzzel entry: the largest image in the program's
# icon, as a PNG in the prefix. Without it the game still starts.
icon="$WINEPREFIX/civ4.png"
if [ ! -f "$icon" ]; then
  tmp=$(mktemp -d)
  if wrestool -x -t 14 -o "$tmp" "$exe" 2>/dev/null; then
    for ico in "$tmp"/*.ico; do
      icotool -x -o "$tmp" "$ico" 2>/dev/null || true
    done
  fi
  # icotool names each image NAME_INDEX_WIDTHxHEIGHTxDEPTH.png: sort on the
  # width, then the colour depth, and take the last one.
  best=$(find "$tmp" -name '*.png' \
    | sed -E 's/.*_([0-9]+)x[0-9]+x([0-9]+)\.png$/\1 \2 &/' \
    | sort -k1,1n -k2,2n | tail -n 1 | cut -d' ' -f3-)
  if [ -n "$best" ]; then
    cp "$best" "$icon"
  else
    echo "No icon found in Civ4BeyondSword.exe; the fuzzel entry stays without one." >&2
  fi
  rm -rf "$tmp"
fi

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
font_scale=""
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

# Text size: the sizes in the game's theme file times font_scale, always
# computed from an untouched copy of that file (kept next to it as .orig).
thm="$bts/Resource/Themes/Civ4/Civ4Theme_Common.thm"
if [ -f "$thm" ]; then
  if [ ! -f "$thm.orig" ]; then
    cp "$thm" "$thm.orig"
  fi
  if [ -n "$font_scale" ]; then
    # Lines like: GFont .Size1_Normal = GFont("Sylfaen", "Regular", 15, ...);
    # the number after the font and the style is the size.
    awk -v f="$font_scale" '
      /^[ \t]*GFont[ \t]+\.Size[0-9]/ && match($0, /"[^"]*"[ \t]*,[ \t]*"[^"]*"[ \t]*,[ \t]*[0-9]+/) {
        seg = substr($0, RSTART, RLENGTH)
        size = seg
        sub(/.*,[ \t]*/, "", size)
        sub(/[0-9]+$/, int(size * f + 0.5), seg)
        $0 = substr($0, 1, RSTART - 1) seg substr($0, RSTART + RLENGTH)
        changed++
      }
      { print }
      END { if (!changed) print "No font sizes found in the theme file; font_scale not applied." > "/dev/stderr" }
    ' "$thm.orig" > "$thm.new"
    mv "$thm.new" "$thm"
  else
    cp "$thm.orig" "$thm"
  fi
else
  echo "Theme file not found, font_scale not applied: $thm" >&2
fi

cd "$bts"
exec wine Civ4BeyondSword.exe "$@"
