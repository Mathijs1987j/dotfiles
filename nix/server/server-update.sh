# GENERATED from config.org ("Home server / Nightly updates"). Do not edit; edit config.org.
# server-update: run nightly by systemd, as root. Nix defines $user, $home,
# $repo and $host before this text.
as_user() { runuser -u "$user" -- env HOME="$home" "$@"; }

# 1. What the laptop pushed. --ff-only: the server never makes commits.
as_user git -C "$repo" pull --ff-only --quiet

# 2. Build that commit, as you.
system=$(as_user nix build --no-link --print-out-paths \
  "$repo#nixosConfigurations.$host.config.system.build.toplevel")

# 3. Switch now, if it differs from what runs.
if [ "$(readlink -f /run/current-system)" != "$system" ]; then
  nix-env --profile /nix/var/nix/profiles/system --set "$system"
  "$system/bin/switch-to-configuration" switch
  echo "server-update: switched to the new system"
else
  echo "server-update: already up to date"
fi

# 4. A new kernel only runs after a reboot.
if [ "$(readlink -f /run/booted-system/kernel)" != "$(readlink -f /run/current-system/kernel)" ]; then
  echo "server-update: new kernel; rebooting"
  systemctl reboot
fi
