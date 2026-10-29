# GENERATED from config.org ("Programming / Python"). Do not edit; edit config.org.
# nix/desktop/python.nix: uv, nix-ld, Node.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    python3 # quick scripts; projects use uv
    uv
    nodejs
  ];
  environment.sessionVariables.UV_PYTHON_PREFERENCE = "only-managed";

  # Lets ordinary Linux programs (uv's Python, binary wheels, downloaded
  # tools) find a program loader and these libraries.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ (numpy, most C++ wheels)
      zlib
      zstd
      openssl
      libffi
      glib
      libGL # matplotlib and Qt windows
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
}
