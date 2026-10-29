# GENERATED from config.org ("Every machine / Git and GitHub"). Do not edit; edit config.org.
# nix/core/git.nix: gh, and the link to git's settings.
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gh ];
  dotfiles.links.".config/git/config" = "live/git/config";
}
