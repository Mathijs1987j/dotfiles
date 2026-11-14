# GENERATED from config.org ("Internet / qBittorrent on the server"). Do not edit; edit config.org.
# nix/desktop/qbittorrent-web.nix: the qbittorrent-web command and its launcher entry.
{ ... }:

{
  dotfiles.links = {
    ".local/bin/qbittorrent-web" = "live/bin/qbittorrent-web";
    ".local/share/applications/qbittorrent-web.desktop" = "live/applications/qbittorrent-web.desktop";
  };
}
