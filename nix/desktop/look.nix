# GENERATED from config.org ("Desktop / Look"). Do not edit; edit config.org.
# nix/desktop/look.nix: themes, dark mode, cursor.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
  ];

  # The wallpaper: NixOS's own artwork in the desktop's colours, at a fixed
  # path for niri's swaybg line. Others: catppuccin-macchiato, nineish-
  # catppuccin-mocha, simple-dark-gray, gradient-grey, dracula, ...
  environment.etc."wallpaper.png".source =
    pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath;

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Adwaita";
        cursor-theme = "Adwaita";
      };
    }
  ];

  dotfiles.links = {
    ".config/gtk-3.0/settings.ini" = "live/gtk/gtk-3.0.ini";
    ".config/gtk-4.0/settings.ini" = "live/gtk/gtk-4.0.ini";
  };
}
