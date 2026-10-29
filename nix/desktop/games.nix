# GENERATED from config.org ("Games"). Do not edit; edit config.org.
# nix/desktop/games.nix: Caesar III (Augustus) and Civilization IV with BUG,
# installed by their launchers from the files in ~/Games/installers.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.games;
  installers = "/home/${username}/Games/installers";

  # A launcher: shell variables from SETTINGS, the shared functions, the script.
  launcher =
    name: script: settings: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text =
        lib.concatStrings (lib.mapAttrsToList (k: v: "${k}=${lib.escapeShellArg v}\n") settings)
        + builtins.readFile ./games/common.sh
        + builtins.readFile script;
    };

  entry =
    name: desktopName:
    pkgs.makeDesktopItem {
      inherit name desktopName;
      exec = name;
      icon = "applications-games";
      categories = [ "Game" ];
    };

  caesar3 = launcher "caesar3" ./games/caesar3.sh {
    inherit installers;
    installer = cfg.caesar3.installer;
    sha256 = cfg.caesar3.sha256;
  } (with pkgs; [ augustus innoextract coreutils findutils ]);

  civ4 = launcher "civ4" ./games/civ4.sh {
    inherit installers;
    installer = cfg.civ4.installer;
    sha256 = cfg.civ4.sha256;
    bug = cfg.civ4.bug;
    bug_sha256 = cfg.civ4.bugSha256;
  } (with pkgs; [ winePackages.stable winetricks coreutils findutils unzip cabextract ]);
in
{
  options.games = {
    caesar3 = {
      enable = lib.mkEnableOption "Caesar III, played through Augustus";
      installer = lib.mkOption {
        type = lib.types.str;
        default = "setup_caesar*.exe";
        description = "Name pattern of GOG's offline installer in ~/Games/installers.";
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Its SHA-256 checksum; empty: not checked (the launcher prints it).";
      };
    };
    civ4 = {
      enable = lib.mkEnableOption "Civilization IV: The Complete Edition under Wine, with BUG";
      installer = lib.mkOption {
        type = lib.types.str;
        default = "setup_*civilization*.exe";
        description = "Name pattern of GOG's offline installer (its .bin parts sit next to it).";
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The installer's SHA-256 checksum; empty: not checked.";
      };
      bug = lib.mkOption {
        type = lib.types.str;
        default = "BUG*.zip";
        description = "Name pattern of the BUG mod's zip, from civ4bug.sourceforge.net.";
      };
      bugSha256 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The zip's SHA-256 checksum; empty: not checked.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.caesar3.enable || cfg.civ4.enable) {
      dotfiles.folders = [ "Games/installers" ];
    })
    (lib.mkIf cfg.caesar3.enable {
      users.users.${username}.packages = [
        caesar3
        (entry "caesar3" "Caesar III")
      ];
    })
    (lib.mkIf cfg.civ4.enable {
      hardware.graphics.enable32Bit = true; # 32-bit graphics for a 32-bit game
      users.users.${username}.packages = [
        civ4
        (entry "civ4" "Civilization IV: Beyond the Sword")
      ];
    })
  ];
}
