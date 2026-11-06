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
}
