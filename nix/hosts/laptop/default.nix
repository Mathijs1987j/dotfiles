# GENERATED from config.org ("Machines / laptop"). Do not edit; edit config.org.
# nix/hosts/laptop/default.nix: the new laptop.
{ pkgs, hostName, ... }:

{
  # Written by the installer (disks, LUKS encryption, kernel modules,
  # microcode). Copy it next to this file and `git add` it before installing.
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = hostName; # "laptop", from flake.nix

  # An internal disk may register itself in the firmware's boot menu.
  boot.loader.efi.canTouchEfiVariables = true;

  # Games (chapter "Games"): installed from ~/Games/installers on first start.
  games.caesar3.enable = true;
  games.civ4.enable = true;

  # Very new hardware sometimes needs the newest kernel:
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # If the laptop is a TUXEDO: drivers for keyboard backlight, fans and
  # power profiles (also look up the model on github.com/NixOS/nixos-hardware).
  # hardware.tuxedo-drivers.enable = true;

  # The release this machine was installed with. Set it at installation to
  # the value of "The NixOS release" at that moment; never change it after.
  system.stateVersion = "26.05";
}
