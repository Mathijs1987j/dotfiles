# GENERATED from config.org ("User: mathijs / Applications"). Do not edit; edit config.org.
# home/apps.nix: your (private) applications. The browser: browser.nix.
{ config, pkgs, ... }:

let
  # whatsapp-web: WhatsApp Web in a window of its own, on the "chat"
  # workspace (Mod+Shift+W in niri; chapter 17.5). It is LibreWolf with a
  # separate profile, so it runs as a separate LibreWolf process: links and
  # windows of your normal browser stay apart. --name gives its window the
  # Wayland app id "whatsapp", which niri's window rule matches. The profile
  # keeps the WhatsApp login (scan the QR code once).
  whatsapp-web = pkgs.writeShellApplication {
    name = "whatsapp-web";
    text = ''
      profile="${config.xdg.dataHome}/librewolf-whatsapp"
      mkdir -p "$profile"
      exec ${config.programs.librewolf.finalPackage}/bin/librewolf \
        --profile "$profile" --name whatsapp --class whatsapp \
        https://web.whatsapp.com "$@"
    '';
  };
in
{
  home.packages = with pkgs; [
    signal-desktop
    whatsapp-web # WhatsApp Web in its own window (defined above)
    thunderbird # mail and calendars; Microsoft 365 via IMAP or Graph (chapter 1.6)
    libreoffice
    shotcut
    musescore
    mpv # video
    loupe # images
    papers # PDFs
    spotify
    qbittorrent
    heroic # GOG games (Civ IV), via Wine/Proton
    augustus # Caesar 3 engine; point it at your GOG game files
    nautilus # graphical file manager
    gnome-disk-utility # "Disks": format drives, check health (chapter 16)
    seahorse # view the keyring: passwords, SSH keys (chapter 12)
  ];

  # A launcher entry, so WhatsApp also appears in fuzzel (Mod+D).
  xdg.desktopEntries.whatsapp-web = {
    name = "WhatsApp (web)";
    exec = "whatsapp-web";
    icon = "librewolf";
    categories = [ "Network" "Chat" ];
    settings.StartupWMClass = "whatsapp";
  };
}
