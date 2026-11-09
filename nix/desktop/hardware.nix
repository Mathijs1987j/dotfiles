# GENERATED from config.org ("Desktop / Hardware"). Do not edit; edit config.org.
# nix/desktop/hardware.nix: graphics, Bluetooth, power, sound, disks.
{ ... }:

{
  hardware.graphics.enable = true; # Mesa: OpenGL/Vulkan, video decoding

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true; # the Bluetooth manager and tray applet

  services.power-profiles-daemon.enable = true; # balanced / power-saver / performance
  services.upower.enable = true; # battery information for the bar

  services.pulseaudio.enable = false;
  security.rtkit.enable = true; # real-time priority for PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # 32-bit programs (games under Wine)
    pulse.enable = true; # programs that speak PulseAudio
  };

  services.udisks2.enable = true; # mounting USB disks (udiskie, file managers)
  services.gvfs.enable = true; # trash, phones and network shares in file managers
  # External drives formatted for Windows (WD Elements: NTFS or exFAT). The
  # kernel reads and writes both; this adds the ntfs-3g tools (ntfsfix).
  boot.supportedFilesystems.ntfs = true;
  # NixOS's kernel also builds =tiny_power_button=, which turns the power-button
  # signal the firmware sends on waking from sleep into an immediate power-off
  # (nixpkgs issue #577729, kernel 6.18.57). The normal =button= driver handles
  # the power button fine, so the tiny one is switched off. Remove this line
  # once the issue is closed.
  boot.blacklistedKernelModules = [ "tiny_power_button" ];
}
