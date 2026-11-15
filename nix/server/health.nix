# GENERATED from config.org ("Home server / Health and backups"). Do not edit; edit config.org.
# nix/server/health.nix: drive health, and nightly backups to the torrent drive.
{ username, ... }:

{
  services.thermald.enable = true; # slows the processor down before it overheats
  services.smartd = {
    enable = true; # watches every drive's health (smartctl -a /dev/sdX by hand)
    autodetect = true;
  };

  # The backup goes in a folder on the torrent drive (/srv/torrents); no
  # mount of its own.
  services.restic.backups.server = {
    repository = "/srv/torrents/server-backup/restic";
    passwordFile = "/var/lib/secrets/restic"; # made by hand; never in git
    initialize = true;
    paths = [ "/var/lib" "/home/${username}" ];
    exclude = [ "/home/${username}/.cache" ];
    timerConfig.OnCalendar = "03:00"; # before the nightly update at 04:00
    pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
  };

  # Back up only when the torrent drive is there.
  systemd.services.restic-backups-server.unitConfig.RequiresMountsFor = [ "/srv/torrents" ];
}
