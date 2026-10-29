# GENERATED from config.org ("Machines / server"). Do not edit; edit config.org.
# nix/hosts/server/default.nix: the HP EliteBook 1050 G1 as home server.
{ hostName, ... }:

{
  imports = [ ./hardware-configuration.nix ]; # written by the installer

  networking.hostName = hostName; # "server", reachable as server.local

  boot.loader.efi.canTouchEfiVariables = true;

  # The EliteBook's left Ctrl key sticks; ignore it (see nixusb).
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
     KEYBOARD_KEY_1d=reserved
  '';

  # A laptop as a server: keep running with the lid closed.
  # (Check the option names in the release notes when you set this up.)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  system.stateVersion = "26.05";
}
