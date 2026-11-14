# GENERATED from config.org ("Machines / server"). Do not edit; edit config.org.
# nix/hosts/server/default.nix: the HP EliteBook 1050 G1 as home server.
{ hostName, ... }:

{
  imports = [ ./hardware-configuration.nix ]; # written by the installer

  networking.hostName = hostName; # "server", reachable as server.local

  boot.loader.efi.canTouchEfiVariables = true;

  # The EliteBook's left Ctrl and left Alt keys stick; ignore them (see
  # nixusb; a server has no desktop, so only this part applies).
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
     KEYBOARD_KEY_1d=reserved
     KEYBOARD_KEY_38=reserved
  '';

  # A laptop as a server: keep running with the lid closed.
  # (Check the option names in the release notes when you set this up.)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # With the lid open (on the bookcase): blank the text console after 60 s,
  # which on most laptops also switches the backlight off. Uncomment to use.
  # boot.kernelParams = [ "consoleblank=60" ];

  # Only if the backlight stays lit: set it to 0 at every boot. Needs pkgs
  # in this file's first line: { pkgs, hostName, ... }:
  # systemd.services.backlight-off = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Type = "oneshot";
  #   script = "${pkgs.brightnessctl}/bin/brightnessctl --class=backlight set 0";
  # };

  system.stateVersion = "26.05";
}
