# GENERATED from config.org ("The flake"). Do not edit; edit config.org.
{
  # flake.nix: the entry point. It names the inputs (where packages and
  # modules come from) and defines one NixOS system per machine.
  # `flake.lock` (created automatically) pins the exact version of every
  # input; commit it together with this file. Chapter 13 explains the layout.
  description = "Mathijs's NixOS and Home Manager configuration";

  inputs = {
    # The base of the system: the stable release. Supported until 31 December
    # 2026; move to 26.11 (here AND for home-manager below) when it is out.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # A second, newer package set, used only for the few packages listed as
    # pkgs.unstable.<name> (Emacs and its tools). See chapter 13.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager: your user-level configuration. Its branch must match the
    # base nixpkgs release.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides emacsWithPackagesFromUsePackage, which reads the use-package
    # forms in emacs/config.el and installs those packages. Applied to the
    # unstable package set, together with Emacs 31.
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # A weekly prebuilt "which package contains this file?" database,
    # used by comma (`, cowsay hello`) and nix-locate. See chapter 14.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      username = "mathijs"; # your login name; change it before installing

      # One function builds every machine: the shared configuration plus the
      # machine's own folder in nixos/hosts/.
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username hostName; };
          modules = [
            ./nixos/configuration.nix
            ./nixos/hosts/${hostName}
          ];
        };
    in
    {
      nixosConfigurations = {
        # The USB test installation on the HP EliteBook:
        #   sudo nixos-rebuild switch --flake ~/dotfiles#nixusb   (or: nh os switch)
        nixusb = mkHost "nixusb";

        # The new laptop, once nixos/hosts/laptop/ exists (chapter 19.8):
        # laptop = mkHost "laptop";
      };
    };
}
