# GENERATED from config.org ("Every machine / Command-line tools"). Do not edit; edit config.org.
# nix/core/cli.nix: command-line tools for every user.
{ pkgs, ... }:

{
  programs.git.enable = true; # flakes need git, also as root

  environment.systemPackages = with pkgs; [
    curl
    wget
    file
    unzip
    pciutils # lspci
    usbutils # lsusb
    smartmontools # smartctl: health of internal and external disks
    ripgrep
    fd
    jq
    btop
    fastfetch
    tealdeer # `tldr tar`: short examples
    yazi # terminal file manager
    powertop # what uses power
    nix-tree # browse what the system consists of, and why
    nix-du # graph of what takes space in the store
    graphviz # `dot`, to draw nix-du's graph
  ];
}
