# GENERATED from config.org ("Every machine / Shell"). Do not edit; edit config.org.
# nix/core/shell.nix: bash's helpers, direnv, ~/.local/bin, and the links.
{ pkgs, ... }:

{
  programs.direnv = {
    enable = true; # per-project environments (.envrc)
    nix-direnv.enable = true;
  };
  environment.localBinInPath = true; # ~/.local/bin on the PATH

  environment.systemPackages = with pkgs; [
    starship # prompt with git branch, Python environment, ...
    fzf # Ctrl-R history, Ctrl-T files, Alt-C folders
    zoxide # `z dotf` jumps to ~/dotfiles
  ];

  dotfiles.links = {
    ".bashrc" = "live/bash/bashrc";
    ".bash_profile" = "live/bash/bash_profile";
    ".local/bin/rebuild" = "live/bin/rebuild";
    ".local/bin/dotfiles-fingerprint" = "live/bin/dotfiles-fingerprint";
  };
}
