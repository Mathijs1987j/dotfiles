# GENERATED from config.org ("Desktop / Fonts and printing"). Do not edit; edit config.org.
# nix/desktop/fonts.nix: fonts and printing.
{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts # broad Unicode coverage
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    dejavu_fonts
    inter # UI font
    nerd-fonts.jetbrains-mono # code font with icons for the bar
  ];

  services.printing.enable = true; # CUPS
}
