# GENERATED from config.org ("Desktop / Bar"). Do not edit; edit config.org.
# nix/desktop/waybar.nix: Waybar as a user service, and its settings files.
{ ... }:

{
  programs.waybar.enable = true; # a systemd user service with the session

  dotfiles.links = {
    ".config/waybar/config.jsonc" = "live/waybar/config.jsonc";
    ".config/waybar/style.css" = "live/waybar/style.css";
    ".local/bin/dotfiles-status" = "live/bin/dotfiles-status";
  };
}
