# GENERATED from config.org ("Home server / Torrents"). Do not edit; edit config.org.
# nix/server/qbittorrent.nix: qBittorrent as a service, with the WD drive.
{ username, ... }:

{
  services.qbittorrent = {
    enable = true;
    user = username; # downloads belong to you
    group = "users";
    webuiPort = 8080; # http://server.local:8080
    torrentingPort = 51413; # the port other peers connect to
    openFirewall = true; # opens both ports
  };

  # The WD drive, NTFS, at /srv/torrents. Change the label to the drive's
  # own (lsblk -f).
  fileSystems."/srv/torrents" = {
    device = "/dev/disk/by-label/WD";
    fsType = "ntfs3";
    options = [
      "uid=1000" # your account (id -u)
      "gid=100" # the users group
      "nofail" # boot without the drive
      "x-systemd.device-timeout=10s"
    ];
  };

  # Start only once the drive is there.
  systemd.services.qbittorrent.unitConfig.RequiresMountsFor = [ "/srv/torrents" ];
}
