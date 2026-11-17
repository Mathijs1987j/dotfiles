# GENERATED from config.org ("Every machine / Tailscale"). Do not edit; edit config.org.
# nix/core/tailscale.nix: Tailscale, the private network between my devices.
{ lib, username, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true; # UDP 41641: lets devices reach each other directly
    useRoutingFeatures = lib.mkDefault "client"; # may use an exit node
    extraSetFlags = [ "--operator=${username}" ]; # `tailscale ...` without sudo
  };
}
