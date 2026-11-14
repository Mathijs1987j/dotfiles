# GENERATED from config.org ("Home server / Nightly updates"). Do not edit; edit config.org.
# nix/server/updates.nix: nightly pull, build and switch; no weekly job here.
{ config, lib, pkgs, username, hostName, ... }:

let
  update = pkgs.writeShellApplication {
    name = "server-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.util-linux # runuser
      config.nix.package
      config.systemd.package
    ];
    text = ''
      user=${lib.escapeShellArg username}
      home=${lib.escapeShellArg config.users.users.${username}.home}
      repo=${lib.escapeShellArg "${config.users.users.${username}.home}/dotfiles"}
      host=${lib.escapeShellArg hostName}
    ''
    + builtins.readFile ./server-update.sh;
  };
in
{
  # Only the laptop writes flake.lock.
  systemd.services.dotfiles-update.enable = false;
  systemd.timers.dotfiles-update.enable = false;

  systemd.services.server-update = {
    description = "Nightly: pull the dotfiles, build, switch; reboot for a new kernel";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    restartIfChanged = false; # never run as a side effect of a switch
    startAt = "*-*-* 04:00:00";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = lib.getExe update;
  };
  systemd.timers.server-update.timerConfig.Persistent = true;

  environment.systemPackages = [ update ];
}
