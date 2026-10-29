# GENERATED from config.org ("Every machine / Boot and firmware"). Do not edit; edit config.org.
# nix/core/boot.nix: boot loader, firmware, swap.
{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # boot-menu entries kept
  # canTouchEfiVariables is set per machine.

  hardware.enableRedistributableFirmware = true; # Wi-Fi, Bluetooth, audio
  services.fwupd.enable = true; # firmware updates: `fwupdmgr update`

  zramSwap.enable = true; # compressed swap in RAM; no swap partition
}
