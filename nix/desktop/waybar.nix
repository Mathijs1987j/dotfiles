# GENERATED from config.org ("Desktop / Bar"). Do not edit; edit config.org.
# nix/desktop/waybar.nix: Waybar as a user service, and its settings files.
{ lib, username, ... }:

{
  programs.waybar.enable = true; # a systemd user service with the session

  # The PATH of a terminal, instead of the minimal one of user services:
  # ~/.local/bin (rebuild, dotfiles-status), then the system's programs.
  systemd.user.services.waybar.environment.PATH = lib.mkForce (
    lib.concatStringsSep ":" [
      "/home/${username}/.local/bin"
      "/run/wrappers/bin"
      "/etc/profiles/per-user/${username}/bin"
      "/run/current-system/sw/bin"
    ]
  );

  dotfiles.links = {
    ".config/waybar/config.jsonc" = "live/waybar/config.jsonc";
    ".config/waybar/style.css" = "live/waybar/style.css";
    ".local/bin/dotfiles-status" = "live/bin/dotfiles-status";
  };
}
