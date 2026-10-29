# GENERATED from config.org ("Foundations / Links, seeds and folders"). Do not edit; edit config.org.
# nix/core/links.nix: the options dotfiles.links, dotfiles.seeds and
# dotfiles.folders, and the program that applies them to your home folder.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.dotfiles;
  repo = "/home/${username}/dotfiles";

  # One line per entry: KIND <tab> TARGET <tab> SOURCE
  manifest = pkgs.writeText "dotfiles-manifest" (
    lib.concatStrings (
      map (dir: "folder\t${dir}\t-\n") cfg.folders
      ++ lib.mapAttrsToList (target: source: "seed\t${target}\t${repo}/${source}\n") cfg.seeds
      ++ lib.mapAttrsToList (target: source: "link\t${target}\t${repo}/${source}\n") cfg.links
    )
  );

  linker = pkgs.writeShellApplication {
    name = "dotfiles-link";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = builtins.readFile ./dotfiles-link.sh;
  };
in
{
  options.dotfiles = {
    links = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Home-relative path -> repository-relative path: made a link.";
    };
    seeds = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Home-relative path -> repository-relative path: copied once.";
    };
    folders = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Home-relative folders to create.";
    };
  };

  config = {
    # Runs as each user, at every activation (rebuild) and at every login.
    system.userActivationScripts.dotfiles = ''
      if [ "$(${pkgs.coreutils}/bin/id -un)" = ${lib.escapeShellArg username} ]; then
        ${linker}/bin/dotfiles-link ${manifest} || echo "dotfiles-link failed" >&2
      fi
    '';

    # Also available by hand:  dotfiles-link /etc/dotfiles-manifest
    environment.systemPackages = [ linker ];
    environment.etc."dotfiles-manifest".source = manifest;
  };
}
