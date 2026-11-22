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

  # The Bluetooth applet: blueman's own unit, started with the session once
  # Waybar's tray is there (see the prose). No ExecStart here: blueman's
  # unit has it, and a second one would be an error.
  systemd.user.services.blueman-applet = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" "waybar.service" ];
    serviceConfig = {
      # Wait (at most 10 s) until Waybar's tray is on the session bus.
      ExecStartPre = pkgs.writeShellScript "wait-for-tray" ''
        for _ in $(seq 50); do
          ${pkgs.systemd}/bin/busctl --user status org.kde.StatusNotifierWatcher \
            >/dev/null 2>&1 && exit 0
          sleep 0.2
        done
        exit 0 # start anyway, rather than not at all
      '';
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
