# GENERATED from config.org ("System (NixOS) / System programs"). Do not edit; edit config.org.
# nixos/modules/programs.nix: programs available to every user (and root),
# and nix-ld for ordinary Linux binaries. Your own applications are in
# ../../home/apps.nix.
{ pkgs, ... }:

{
  # Firefox stays installed system-wide as the fallback browser for sites
  # that misbehave under LibreWolf's stricter settings (chapter 17).
  programs.firefox.enable = true;

  programs.git.enable = true; # flakes need git, also as root

  # nix-ld: lets ordinary Linux programs (uv's Python, pip wheels, VS Code
  # extensions, downloaded binaries) find a dynamic loader and these
  # libraries. Add a library here when a program reports one missing.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ (numpy, most C++ wheels)
      zlib
      zstd
      openssl
      libffi
      glib
      libGL # matplotlib/Qt windows
      libxkbcommon
      fontconfig
      freetype
      dbus
      wayland
      libx11 # X11 libraries for Tk and Qt windows under XWayland
      libxext
      libxrender
      libxi
      libxcursor
      libxrandr
      libxinerama
      libxcb
      tcl
      tk
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    file
    unzip
    pciutils # lspci
    usbutils # lsusb
    smartmontools # smartctl: health of internal and external disks
    xwayland-satellite # X11 apps under niri (niri starts it automatically)
  ];
}
