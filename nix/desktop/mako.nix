# GENERATED from config.org ("Desktop / Notifications"). Do not edit; edit config.org.
# nix/desktop/mako.nix: notifications.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = [ pkgs.mako ];
  dotfiles.links.".config/mako/config" = "live/mako/config";
}
