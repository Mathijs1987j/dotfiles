# GENERATED from config.org ("Foundations / The flake"). Do not edit; edit config.org.
{
  description = "Mathijs's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      username = "mathijs";

      # Every .nix file below DIR, in alphabetical order.
      nixFilesIn =
        dir:
        let
          entries = builtins.readDir dir;
        in
        builtins.concatMap (
          name:
          let
            path = dir + "/${name}";
            type = entries.${name};
          in
          if type == "directory" then
            nixFilesIn path
          else if type == "regular" && builtins.match ".*\\.nix" name != null then
            [ path ]
          else
            [ ]
        ) (builtins.attrNames entries);

      # A machine: the core, the folders of its roles, and its own folder.
      mkHost =
        hostName: roles:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username hostName; };
          modules =
            nixFilesIn ./nix/core
            ++ builtins.concatMap (role: nixFilesIn (./nix + "/${role}")) roles
            ++ [ ./nix/hosts/${hostName} ];
        };
    in
    {
      nixosConfigurations = {
        # The USB test installation (on the EliteBook):
        #   rebuild          (or: nh os switch ~/dotfiles -H nixusb)
        nixusb = mkHost "nixusb" [ "desktop" ];

        # The new laptop: install with  nixos-install --flake .#laptop
        laptop = mkHost "laptop" [ "desktop" ];

        # The EliteBook as home server, once its fan is repaired:
        # server = mkHost "server" [ "server" ];
      };
    };
}
