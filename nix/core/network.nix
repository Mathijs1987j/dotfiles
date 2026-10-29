# GENERATED from config.org ("Every machine / Network"). Do not edit; edit config.org.
# nix/core/network.nix: NetworkManager and mDNS.
{ ... }:

{
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true; # mDNS: printers, and the other machines as <name>.local
    nssmdns4 = true;
    openFirewall = true;
  };
}
