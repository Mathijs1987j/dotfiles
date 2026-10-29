# GENERATED from config.org ("Desktop / Launcher"). Do not edit; edit config.org.
# nix/desktop/fuzzel.nix: the launcher.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = [ pkgs.fuzzel ];
  dotfiles.links.".config/fuzzel/fuzzel.ini" = "live/fuzzel/fuzzel.ini";
}
