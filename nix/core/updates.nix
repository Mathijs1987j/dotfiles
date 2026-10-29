# GENERATED from config.org ("Foundations / Weekly updates"). Do not edit; edit config.org.
# nix/core/updates.nix: the weekly update of flake.lock and of the system
# for the next boot, and the reminder for a new NixOS release.
{
  config,
  lib,
  pkgs,
  username,
  hostName,
  ...
}:

let
  update = pkgs.writeShellApplication {
    name = "dotfiles-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.util-linux # runuser
      config.nix.package
    ];
    text = ''
      user=${lib.escapeShellArg username}
      home=${lib.escapeShellArg config.users.users.${username}.home}
      repo=${lib.escapeShellArg "${config.users.users.${username}.home}/dotfiles"}
      host=${lib.escapeShellArg hostName}
      release=${lib.escapeShellArg "26.05"}
    ''
    + builtins.readFile ./dotfiles-update.sh;
  };
in
{
  systemd.services.dotfiles-update = {
    description = "Weekly update of flake.lock and of the system for the next boot";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    restartIfChanged = false; # never run as a side effect of a rebuild
    startAt = "Mon *-*-* 12:00:00";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe update;
      StateDirectory = "dotfiles-update"; # /var/lib/dotfiles-update
    };
  };

  systemd.timers.dotfiles-update.timerConfig = {
    Persistent = true; # catch up after a week with the machine off
    RandomizedDelaySec = "30min";
  };

  environment.systemPackages = [ update ];
}
