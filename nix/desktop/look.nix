# GENERATED from config.org ("Desktop / Look"). Do not edit; edit config.org.
# nix/desktop/look.nix: themes, dark mode, cursor.
{ pkgs, username, ... }:

let
  # AdwaitaFull: no icons of its own, only the order to look in (see the
  # prose). GTK needs at least one folder in a theme, so it has an empty one.
  adwaita-full = pkgs.runCommand "adwaita-full-icon-theme" { } ''
    theme=$out/share/icons/AdwaitaFull
    mkdir -p $theme/scalable/apps
    cat > $theme/index.theme <<'EOF'
    [Icon Theme]
    Name=AdwaitaFull
    Comment=Adwaita, then the legacy full-colour icons
    Inherits=Adwaita,AdwaitaLegacy,hicolor
    Directories=scalable/apps

    [scalable/apps]
    Size=16
    MinSize=8
    MaxSize=512
    Type=Scalable
    EOF
  '';
in
{
  users.users.${username}.packages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    adwaita-icon-theme-legacy # the older full-colour icons (blueman's devices)
    adwaita-full # the icon theme: Adwaita, then the legacy icons
  ];

  # The wallpaper: NixOS's own artwork in the desktop's colours, at a fixed
  # path for niri's swaybg line. Others: catppuccin-macchiato, nineish-
  # catppuccin-mocha, simple-dark-gray, gradient-grey, dracula, ...
  environment.etc."wallpaper.png".source =
    pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath;

  programs.dconf.enable = true;
  # Qt programs (Shotcut, MuseScore) use the desktop's file picker, with
  # Nautilus's bookmarks and Ctrl+L, instead of Qt's own simple dialog.
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "AdwaitaFull"; # Adwaita, then the legacy icons
        cursor-theme = "Adwaita";
        gtk-key-theme = "Emacs"; # Emacs keys in text fields
      };
    }
  ];

  dotfiles.links = {
    ".config/gtk-3.0/settings.ini" = "live/gtk/gtk-3.0.ini";
    ".config/gtk-4.0/settings.ini" = "live/gtk/gtk-4.0.ini";
  };
}
