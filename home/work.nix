# GENERATED from config.org ("User: work"). Do not edit; edit config.org.
# home/work.nix: an OPTIONAL second account for work (chapter 6.10). Not used
# until you enable it in nixos/configuration.nix. It shares the desktop,
# shell, Emacs and tools with your own account, but not your private apps,
# browser profile, mail, keyring or files.
{ lib, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./terminal.nix
    ./browser.nix
    ./dev.nix
    ./emacs.nix
    ./desktop.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    thunderbird
    libreoffice
  ];

  programs.git.settings.user.email = lib.mkForce "you@school.example";

  # This account cannot read ~mathijs/dotfiles (home folders are private),
  # so it uses copies of niri's and Emacs's configuration from the Nix store.
  # They update when you rebuild.
  xdg.configFile."niri/config.kdl".source = lib.mkForce ./niri/config.kdl;
  home.file.".emacs.d/init.el".text = lib.mkForce ''
    ;;; init.el --- stub written by Home Manager -*- lexical-binding: t; -*-
    (load "${../emacs/config.el}" nil 'nomessage)
  '';

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  home.stateVersion = "26.05";
}
