# GENERATED from config.org ("Desktop / Lock and idle"). Do not edit; edit config.org.
# nix/desktop/lock.nix: swaylock and swayidle.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    swaylock
    swayidle
  ];
  security.pam.services.swaylock = { }; # lets swaylock check your password

  dotfiles.links = {
    ".config/swaylock/config" = "live/swaylock/config";
    ".config/swayidle/config" = "live/swayidle/config";
  };
}
