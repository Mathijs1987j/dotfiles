# GENERATED from config.org ("System (NixOS) / Core"). Do not edit; edit config.org.
# nixos/configuration.nix: the system level, shared by every machine.
# This file holds the core (Nix itself, users, locale, Home Manager) and
# imports one file per topic from ./modules. Everything at this level needs
# root and affects the whole machine. Your personal settings live in ../home/.
{
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    ./modules/hardware.nix # boot, firmware, graphics, sound, network, power, disks
    ./modules/desktop.nix # niri, login screen, fonts, portals, printing
    ./modules/programs.nix # system-wide programs, nix-ld
    inputs.home-manager.nixosModules.home-manager
  ];

  # ---------------------------------------------------------------- Nix
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true; # hard-link identical files in the store
    trusted-users = [ "root" "@wheel" ];
  };
  nixpkgs.config.allowUnfree = true; # Spotify, Mathematica, some firmware

  # pkgs.unstable: the newer package set from the nixpkgs-unstable input,
  # available everywhere as pkgs.unstable.<name>. The emacs-overlay is applied
  # to it (only the part that provides emacsWithPackagesFromUsePackage; the
  # Emacs packages themselves come from nixpkgs). Chapter 13.
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        overlays = [ inputs.emacs-overlay.overlays.emacs ];
      };
    })
  ];

  # nh: friendlier rebuilds (`nh os switch`) with a build tree and a list of
  # changed packages; cleans old generations weekly. Chapter 14.
  programs.nh = {
    enable = true;
    flake = "/home/${username}/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  # ---------------------------------------------------------------- Locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_IE.UTF-8"; # English names, 24-hour clock, day-month order
    LC_PAPER = "nl_NL.UTF-8"; # A4
    LC_MEASUREMENT = "nl_NL.UTF-8"; # metric
  };
  # US international keyboard with AltGr dead keys (` and ' type directly;
  # AltGr+` then a gives à). The same layout is set in niri's config.
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
  console.useXkbConfig = true; # use it on the text console as well

  # ---------------------------------------------------------------- Users
  users.users.${username} = {
    isNormalUser = true;
    description = "Mathijs";
    extraGroups = [
      "wheel" # may use sudo (chapter 6.9)
      "networkmanager" # may change network settings
      "video" # backlight control
    ];
    # Only used for the very first login. Change it at once with `passwd`.
    initialPassword = "changeme";
  };

  # A second, separate account for work (chapter 6.10). Uncomment this block
  # and the `users.work` line in the Home Manager block below, then rebuild.
  # users.users.work = {
  #   isNormalUser = true;
  #   description = "Mathijs (work)";
  #   extraGroups = [ "networkmanager" "video" ];
  #   initialPassword = "changeme";
  # };

  # ---------------------------------------------------------------- Home Manager
  # Home Manager runs as part of every rebuild; it builds your user
  # configuration from ../home/home.nix (chapter 6).
  home-manager = {
    useGlobalPkgs = true; # same pkgs (with pkgs.unstable) as the system
    useUserPackages = true; # user packages land in /etc/profiles/per-user
    backupFileExtension = "hm-backup"; # rename clashing files instead of failing
    extraSpecialArgs = { inherit inputs username; };
    sharedModules = [ inputs.nix-index-database.homeModules.nix-index ];
    users.${username} = import ../home/home.nix;
    # users.work = import ../home/work.nix; # the work account, see above
  };

  # The NixOS release this machine was first installed with. It is NOT the
  # version you run; it keeps old defaults for stateful services stable.
  # Never change it after installing.
  system.stateVersion = "26.05";
}
