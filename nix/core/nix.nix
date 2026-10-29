# GENERATED from config.org ("Every machine / Nix itself"). Do not edit; edit config.org.
# nix/core/nix.nix: Nix settings, pkgs.unstable, nh, nix-index and comma.
{ inputs, username, ... }:

{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true; # hard-link identical files in the store
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
  nixpkgs.config.allowUnfree = true; # Spotify, some firmware

  # pkgs.unstable: the newer package set, everywhere as pkgs.unstable.<name>.
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        overlays = [ inputs.emacs-overlay.overlays.emacs ];
      };
    })
  ];

  # nh: `rebuild` uses it; cleans old generations weekly.
  programs.nh = {
    enable = true;
    flake = "/home/${username}/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  # `, cowsay hi` runs a program without installing it; unknown commands
  # get a package suggestion.
  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false; # nix-index replaces it
}
