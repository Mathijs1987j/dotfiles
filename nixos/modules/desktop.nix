# GENERATED from config.org ("System (NixOS) / Desktop"). Do not edit; edit config.org.
# nixos/modules/desktop.nix: the system half of the desktop. The niri
# compositor, the login screen, fonts and printing. The user half (bar,
# launcher, notifications, look) is in ../../home/desktop.nix.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # The niri compositor. This module also enables polkit, the GNOME and GTK
  # portals (screen sharing, file pickers), gnome-keyring with its SSH agent,
  # dconf and the PAM entry swaylock needs. Settings: ../../home/niri/.
  programs.niri.enable = true;

  # Login screen: greetd with the text greeter tuigreet.
  services.greetd = {
    enable = true;
    useTextGreeter = true; # keep boot messages from drawing over it
    settings.default_session.command = lib.concatStringsSep " " [
      "${pkgs.tuigreet}/bin/tuigreet"
      "--time --remember --remember-session --asterisks"
      "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
      "--cmd niri-session"
    ];
  };

  # A safety-net desktop for the first weeks: uncomment, rebuild, and pick
  # "Plasma" in tuigreet (F3) if your niri setup ever leaves you stuck.
  # services.desktopManager.plasma6.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts # broad Unicode coverage
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    dejavu_fonts
    inter # UI font
    nerd-fonts.jetbrains-mono # code font with icons for the bar
  ];

  # ---------------------------------------------------------------- Printing
  services.printing.enable = true; # CUPS
  services.avahi = {
    enable = true; # finds network printers (driverless IPP Everywhere)
    nssmdns4 = true;
    openFirewall = true;
  };

  # ---------------------------------------------------------------- Apps from Flathub
  services.flatpak.enable = true; # e.g. Spotify; chapter 19.6
}
