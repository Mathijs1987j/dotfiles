# GENERATED from config.org ("Desktop / niri"). Do not edit; edit config.org.
# nix/desktop/niri.nix: niri, the programs its key bindings use, the links.
{ pkgs, username, ... }:

{
  programs.niri.enable = true;
  environment.systemPackages = [ pkgs.xwayland-satellite ]; # X11 programs

  users.users.${username}.packages = with pkgs; [
    swaybg # wallpaper
    brightnessctl # backlight keys
    playerctl # media keys
    pwvucontrol # volume mixer (PipeWire)
    satty # annotate screenshots: wl-paste | satty -f -
    wl-mirror # mirror the screen to a projector (Mod+P)
    jq # used by the scripts and by niri msg --json
  ];

  dotfiles.links = {
    ".config/niri/config.kdl" = "live/niri/config.kdl";
    ".local/bin/run-or-raise" = "live/bin/run-or-raise";
    ".local/bin/power-menu" = "live/bin/power-menu";
  };
  dotfiles.folders = [ "Pictures/Screenshots" ];
}
