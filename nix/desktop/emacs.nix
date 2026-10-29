# GENERATED from config.org ("Emacs / Packaging"). Do not edit; edit config.org.
# nix/desktop/emacs.nix: Emacs 31 with the packages named in config.el, the
# daemon, and the links to the stub and the `tangle-config` command.
{ pkgs, ... }:

let
  emacs = pkgs.unstable.emacsWithPackagesFromUsePackage {
    config = ../../live/emacs/config.el;
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
      epkgs.mu4e # mail in Emacs; used once mail.mu4e is switched on
    ];
  };
in
{
  services.emacs = {
    enable = true; # the daemon, as a systemd user service
    package = emacs;
    startWithGraphical = true; # with the niri session
    defaultEditor = true; # EDITOR=emacsclient
  };
  environment.systemPackages = [ emacs ];

  dotfiles.links = {
    ".emacs.d/init.el" = "live/emacs/init.el";
    ".local/bin/tangle-config" = "live/bin/tangle-config";
  };
}
