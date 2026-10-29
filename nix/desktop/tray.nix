# GENERATED from config.org ("Desktop / Tray and helpers"). Do not edit; edit config.org.
# nix/desktop/tray.nix: tray applets and session helpers.
{ pkgs, username, ... }:

{
  programs.nm-applet = {
    enable = true; # Wi-Fi menu in the tray
    indicator = true;
  };

  # The polkit agent: "enter your password" dialogs for administrative actions.
  systemd.user.services.polkit-gnome-agent = {
    description = "polkit agent (password dialogs)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  users.users.${username}.packages = with pkgs; [
    udiskie # mount USB drives, tray icon to eject
    wlsunset # warmer screen colours in the evening
    wl-clipboard # wl-copy / wl-paste
    cliphist # clipboard history
    libnotify # notify-send (Mod+Shift+I)
  ];
}
