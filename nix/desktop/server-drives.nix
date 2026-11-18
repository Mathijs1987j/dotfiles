# GENERATED from config.org ("Desktop / The server's drives"). Do not edit; edit config.org.
# nix/desktop/server-drives.nix: the server's /srv at /mnt/server, over NFS.
{ ... }:

{
  boot.supportedFilesystems.nfs = true; # the NFS client

  fileSystems."/mnt/server" = {
    device = "server:/"; # the server's /srv, by its Tailscale name
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noauto" # not at boot ...
      "x-systemd.automount" # ... but the first time something opens it
      "x-systemd.idle-timeout=10min" # let go when unused
      "x-systemd.mount-timeout=20s" # give up when the server can't be reached
      "_netdev" # it needs the network
      "soft" # a lost connection gives an error instead of freezing programs
      "timeo=50" # wait 5 s for an answer ...
      "retrans=2" # ... and try twice more before giving up
    ];
  };
}
