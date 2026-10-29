# GENERATED from config.org ("Every machine / tmux"). Do not edit; edit config.org.
# nix/core/tmux.nix: tmux and its settings file.
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tmux ];
  dotfiles.links.".config/tmux/tmux.conf" = "live/tmux/tmux.conf";
}
