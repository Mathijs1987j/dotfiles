# GENERATED from config.org ("System (NixOS) / Hardware"). Do not edit; edit config.org.
# nixos/modules/hardware.nix: boot, firmware, graphics, sound, networking,
# power and disks. Settings for one specific machine go in nixos/hosts/.
{ ... }:

{
  # ---------------------------------------------------------------- Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # boot-menu entries kept
  # canTouchEfiVariables is set per machine (see hosts/).

  # ---------------------------------------------------------------- Firmware and graphics
  hardware.enableRedistributableFirmware = true; # Wi-Fi, Bluetooth, audio (SOF)
  hardware.graphics.enable = true; # Mesa: OpenGL/Vulkan, video decoding
  services.fwupd.enable = true; # firmware updates: `fwupdmgr update`

  # ---------------------------------------------------------------- Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true; # D-Bus part of the Bluetooth applet

  # ---------------------------------------------------------------- Power
  services.power-profiles-daemon.enable = true; # balanced / power-saver / performance
  services.upower.enable = true; # battery information for the bar

  # Compressed swap in RAM: no swap partition needed (chapter 16.6).
  zramSwap.enable = true;

  # ---------------------------------------------------------------- Network
  networking.networkmanager.enable = true; # `nmtui` in a terminal, or the applet
  # The firewall is on by default; open ports only when you need them.

  # ---------------------------------------------------------------- Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true; # real-time priority for PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # 32-bit games (Wine)
    pulse.enable = true; # apps that speak PulseAudio
  };

  # ---------------------------------------------------------------- Disks
  services.udisks2.enable = true; # mounting USB disks (udiskie, file managers)
  services.gvfs.enable = true; # trash, phones and network shares in file managers
  # External drives formatted for Windows (WD Elements: NTFS or exFAT).
  # exFAT and the kernel's NTFS driver work out of the box; this adds the
  # ntfs-3g tools (ntfsfix, mkntfs) and its driver as a fallback. Chapter 16.7.
  boot.supportedFilesystems.ntfs = true;
}
