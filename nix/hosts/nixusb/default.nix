# GENERATED from config.org ("Machines / nixusb"). Do not edit; edit config.org.
# nix/hosts/nixusb/default.nix: the USB test installation.
{ hostName, ... }:

{
  imports = [
    ./hardware-configuration.nix # written by the installer; copy it in
  ];

  networking.hostName = hostName; # "nixusb", from flake.nix

  # Boot loader on a USB disk: do NOT write boot entries into the laptop's
  # firmware (that is where Windows's entry lives). systemd-boot still
  # installs itself as the removable-media fallback (EFI/BOOT/BOOTX64.EFI),
  # so the stick boots from the firmware's one-time boot menu (Esc, F9 on HP).
  boot.loader.efi.canTouchEfiVariables = false;

  # Make sure the USB disk can be found early in boot on any machine.
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usb_storage"
    "uas"
    "sd_mod"
  ];

  # Fewer writes to the USB disk: don't record when files were last read.
  fileSystems."/".options = [ "noatime" ];

  # The EliteBook's built-in keyboard is broken: its left Ctrl and left Alt
  # keys now and then send a press without a release, so Linux thinks the
  # key is held down (with Ctrl, m acts as Enter and i as Tab; with Alt,
  # every key becomes a shortcut). Use the external keyboard.
  #
  # 1. The desktop (niri, the lock screen, every program) ignores the
  #    built-in keyboard completely. libinput, which niri uses for input,
  #    skips devices marked LIBINPUT_IGNORE_DEVICE. The BIOS and the text
  #    login prompt don't use libinput: there the keyboard still works.
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event*", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
  # 2. Where it still works, ignore the two bad keys: scancodes 1d (left
  #    Ctrl) and 38 (left Alt), found with evtest. atkbd matches only
  #    built-in keyboards, never the external USB one. Each KEYBOARD_KEY
  #    line needs exactly one space more than the evdev line; Nix removes
  #    the common indentation of the '' string.
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
     KEYBOARD_KEY_1d=reserved
     KEYBOARD_KEY_38=reserved
  '';

  # No games here: the EliteBook's fan is broken and Civilization IV makes
  # it overheat. They are switched on for the laptop.

  # The release this machine was installed with. Never change it.
  system.stateVersion = "26.05";
}
