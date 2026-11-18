# GENERATED from config.org ("Home server / The drives on the laptop"). Do not edit; edit config.org.
# nix/server/nfs.nix: /srv shared with the laptop over NFS, through Tailscale only.
{ username, ... }:

{
  # /srv is the root the laptop mounts (fsid=0); the drives in it are
  # shared too, each only while it is mounted (mp). Only the laptop's
  # Tailscale address may connect; whatever it writes belongs to you
  # (all_squash with your account's numbers, 1000 and the users group).
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv          100.111.254.123(rw,fsid=0,crossmnt,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /srv/data     100.111.254.123(rw,mp,fsid=1,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /srv/torrents 100.111.254.123(rw,mp,fsid=2,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /srv/archive  100.111.254.123(rw,mp,fsid=3,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };

  # Share the drives only after they have been mounted (or given up on).
  systemd.services.nfs-server.after = [
    "srv-data.mount"
    "srv-torrents.mount"
    "srv-archive.mount"
  ];

  # NFS version 4 needs this one port; only through Tailscale.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 2049 ];

  systemd.tmpfiles.rules = [
    "z /srv/data 0755 ${username} users -" # the data drive's top folder is yours
    "d /srv/scratch 0755 ${username} users -" # spare room on the system drive
  ];
}
