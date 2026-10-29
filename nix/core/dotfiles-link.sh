# GENERATED from config.org ("Foundations / Links, seeds and folders"). Do not edit; edit config.org.
# dotfiles-link MANIFEST: make the home folder match MANIFEST, a list
# written by Nix with one line per entry:  KIND <tab> TARGET <tab> SOURCE
#   folder TARGET -       create the folder ~/TARGET
#   seed   TARGET SOURCE  copy SOURCE to ~/TARGET once, if nothing is there
#   link   TARGET SOURCE  make ~/TARGET a link to SOURCE
# Links made by an earlier run that the manifest no longer lists are
# removed, as long as they still point into ~/dotfiles.

manifest=$1
repo="$HOME/dotfiles"
state="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
mkdir -p "$state"
made=$(mktemp)
trap 'rm -f "$made"' EXIT

while IFS=$'\t' read -r kind target source; do
  dest="$HOME/$target"
  case "$kind" in
    folder)
      mkdir -p "$dest"
      ;;
    seed)
      if [ ! -e "$dest" ] && [ ! -L "$dest" ] && [ -e "$source" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -R --no-preserve=mode,ownership "$source" "$dest"
        echo "dotfiles: copied ~/$target (yours to change from now on)"
      fi
      ;;
    link)
      if [ ! -e "$source" ]; then
        echo "dotfiles: skipped ~/$target: $source does not exist" >&2
        continue
      fi
      if [ "$(readlink "$dest" || true)" != "$source" ]; then
        if [ -L "$dest" ]; then
          rm "$dest"
        elif [ -e "$dest" ]; then
          backup="$dest.before-dotfiles"
          if [ -e "$backup" ]; then
            backup="$backup.$(date +%Y%m%d%H%M%S)"
          fi
          mv "$dest" "$backup"
          echo "dotfiles: moved the existing ~/$target to $backup"
        fi
        mkdir -p "$(dirname "$dest")"
        ln -s "$source" "$dest"
        echo "dotfiles: linked ~/$target"
      fi
      printf '%s\n' "$target" >> "$made"
      ;;
  esac
done < "$manifest"

# Links from an earlier run that are no longer wanted.
if [ -f "$state/links" ]; then
  while IFS= read -r target; do
    dest="$HOME/$target"
    if [ -L "$dest" ] && ! grep -qxF -- "$target" "$made"; then
      case "$(readlink "$dest")" in
        "$repo"/*)
          rm "$dest"
          echo "dotfiles: removed ~/$target (no longer in config.org)"
          ;;
      esac
    fi
  done < "$state/links"
fi
sort -u "$made" > "$state/links"
