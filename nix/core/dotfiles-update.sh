# GENERATED from config.org ("Foundations / Weekly updates"). Do not edit; edit config.org.
# dotfiles-update: run weekly by systemd, as root. Nix defines $user, $repo,
# $home, $host and $release before this text.
# As you, with your own home folder (for git's settings and Nix's cache).
as_user() { runuser -u "$user" -- env HOME="$home" "$@"; }

# 1. Newer versions of every input.
as_user nix flake update --flake "$repo"

if as_user git -C "$repo" diff --quiet -- flake.lock; then
  echo "dotfiles-update: everything was already up to date"
else
  # 2. Build the new system as you; on failure keep the old flake.lock.
  if ! system=$(as_user nix build --no-link --print-out-paths \
    "$repo#nixosConfigurations.$host.config.system.build.toplevel"); then
    as_user git -C "$repo" checkout -- flake.lock
    echo "dotfiles-update: the build failed; flake.lock is unchanged" >&2
    exit 1
  fi
  # 3. The default for the next boot (what `nixos-rebuild boot` does).
  nix-env --profile /nix/var/nix/profiles/system --set "$system"
  "$system/bin/switch-to-configuration" boot
  # 4. Keep the new flake.lock, and nothing else, in git.
  as_user git -C "$repo" commit --quiet -m "flake.lock: weekly update" -- flake.lock
  echo "dotfiles-update: the new system starts at the next boot"
fi

# 5. Is the next NixOS release out? (YY.05 is followed by YY.11, YY.11 by YY+1.05.)
year=${release%.*}
month=${release#*.}
if [ "$month" = 05 ]; then
  next="$year.11"
else
  next="$((10#$year + 1)).05"
fi
if git ls-remote --exit-code --heads https://github.com/NixOS/nixpkgs "nixos-$next" > /dev/null 2>&1; then
  echo "$next" > /var/lib/dotfiles-update/new-release
else
  rm -f /var/lib/dotfiles-update/new-release
fi
