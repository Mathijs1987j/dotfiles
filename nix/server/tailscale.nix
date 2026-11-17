# GENERATED from config.org ("Home server / Away from home"). Do not edit; edit config.org.
# nix/server/tailscale.nix: what only the server does on the tailnet.
{ ... }:

{
  services.tailscale = {
    useRoutingFeatures = "server"; # may pass traffic on (exit node)
    extraSetFlags = [
      "--accept-dns=false" # it is the DNS server: it must not ask itself
      # "--advertise-exit-node" # offer the home connection to my devices
    ];
  };
}
