# GENERATED from config.org ("Internet / Passwords"). Do not edit; edit config.org.
# nix/desktop/passwords.nix: KeePassXC, its link to the browsers, its settings.
{ pkgs, ... }:

{
  # System-wide, so /run/current-system/sw/bin/keepassxc-proxy always exists
  # and the browser manifest below never points at an old version.
  environment.systemPackages = [ pkgs.keepassxc ];

  # Firefox (the fallback) gets KeePassXC's own manifest through its module.
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.keepassxc ];

  # LibreWolf: the manifest from this file, in the old folder and in both
  # candidates of the new (XDG) layout.
  dotfiles.links = {
    ".librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json" =
      "live/keepassxc/org.keepassxc.keepassxc_browser.json";
    ".config/librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json" =
      "live/keepassxc/org.keepassxc.keepassxc_browser.json";
    ".config/librewolf/librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json" =
      "live/keepassxc/org.keepassxc.keepassxc_browser.json";
  };

  # KeePassXC rewrites its settings: a starting copy, then its own.
  dotfiles.seeds.".config/keepassxc/keepassxc.ini" = "live/keepassxc/keepassxc.ini";

  # Started with the session, once the tray is there (see the prose).
  systemd.user.services.keepassxc = {
    description = "KeePassXC password manager";
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
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      Restart = "on-failure";
    };
  };
}
