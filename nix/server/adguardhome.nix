# GENERATED from config.org ("Home server / Ad blocking"). Do not edit; edit config.org.
# nix/server/adguardhome.nix: AdGuard Home, the DNS filter for the home network.
{ ... }:

{
  services.adguardhome = {
    enable = true;
    port = 3000; # the web page: http://server.local:3000
    openFirewall = true; # opens the web page's port only, not DNS
    # allowDHCP = true; # only when AdGuard Home also hands out addresses
  };

  # DNS itself: port 53, over UDP and (for long answers) over TCP.
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ]; # 67 as well for DHCP
}
