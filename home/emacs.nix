# GENERATED from config.org ("User: mathijs / Emacs packaging"). Do not edit; edit config.org.
# home/emacs.nix: Emacs 31 with the packages named in your configuration,
# and the Emacs daemon. Chapter 9.
{ pkgs, ... }:

{
  # Packages are read from the use-package forms in emacs/config.el (the
  # tangled file, committed in the repository). After adding a package to
  # config.org: save (tangles), rebuild, restart the daemon, commit.
  # Emacs and its packages come from pkgs.unstable (chapter 13).
  programs.emacs = {
    enable = true;
    package = pkgs.unstable.emacsWithPackagesFromUsePackage {
      config = ../emacs/config.el;
      package = pkgs.unstable.emacs-pgtk; # Wayland-native Emacs 31
      alwaysEnsure = true; # use-package forms without :ensure nil are installed
      extraEmacsPackages = epkgs: [
        (epkgs.treesit-grammars.with-grammars (g: [
          g.tree-sitter-python
          g.tree-sitter-javascript
          g.tree-sitter-css
          g.tree-sitter-html
          g.tree-sitter-json
          g.tree-sitter-nix
        ]))
        epkgs.mu4e # mail in Emacs; used once email.nix is enabled
      ];
    };
  };

  # The Emacs daemon: starts with the graphical session;
  # `emacsclient -c` (Mod+E in niri) opens a frame instantly.
  services.emacs = {
    enable = true;
    client.enable = true; # adds an "Emacs (Client)" launcher entry
    startWithUserSession = "graphical";
    defaultEditor = true; # EDITOR=emacsclient for git, sudoedit, ...
  };

  # The stub init.el: loads the real configuration from the repository.
  # It is the only Emacs file outside the repository (chapter 20).
  home.file.".emacs.d/init.el".text = ''
    ;;; init.el --- stub written by Home Manager -*- lexical-binding: t; -*-
    (load (expand-file-name "~/dotfiles/emacs/config.el") nil 'nomessage)
  '';
}
