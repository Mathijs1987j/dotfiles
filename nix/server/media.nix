# GENERATED from config.org ("Home server / Films, music and sharing"). Do not edit; edit config.org.
# nix/server/media.nix: the second WD drive, and a read-only download folder.
{ ... }:

{
  # The WD 18 TB drive, NTFS, at /srv/archive, by its UUID (lsblk -f).
  fileSystems."/srv/archive" = {
    device = "/dev/disk/by-uuid/9AC024A4C0248919";
    fsType = "ntfs3";
    options = [
      "uid=1000" # your account (id -u)
      "gid=100" # the users group
      "nofail" # boot without the drive
      "x-systemd.device-timeout=10s"
    ];
  };

  # The download folder: /srv/share as a list of links, read-only, on port
  # 8090. Links in /srv/share may point anywhere on the drives.
  services.nginx = {
    enable = true;
    virtualHosts.share = {
      listen = [ { addr = "0.0.0.0"; port = 8090; } ];
      root = "/srv/share";
      locations."/".extraConfig = ''
        autoindex on; # show the folder as a list
        autoindex_exact_size off; # sizes as 1G, 700M
        limit_except GET { deny all; } # reading only (GET also covers HEAD)
        limit_rate 5m; # at most 5 MB/s per download
      '';
    };
  };

  # Reachable only through Tailscale, never from the home network or the
  # internet.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8090 ];
}
