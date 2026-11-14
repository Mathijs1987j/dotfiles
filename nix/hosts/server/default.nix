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

  # A laptop as a server: keep running when the lid is closed.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # With the lid open (on the bookcase): blank the text console after 60 s,
  # which also switches the backlight off. Applies after a reboot; if the
  # screen stays lit after a deploy, reboot once.
  boot.kernelParams = [ "consoleblank=60" ];

  # The screen's backlight off at every start, and at the deploy that adds
  # this, whatever the console does (blanking alone did not last).
  systemd.services.backlight-off = {
    description = "Switch the screen's backlight off";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for d in /sys/class/backlight/*; do
        echo 0 > "$d/brightness"
      done
    '';
  };

  system.stateVersion = "26.05";
}
