# GENERATED from config.org ("Home server / Reaching the server"). Do not edit; edit config.org.
# nix/server/ssh.nix: SSH with keys only, and the name server.local.
{ username, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.${username}.openssh.authorizedKeys.keys = [
    # "ssh-ed25519 AAAA... mathijs@laptop"
  ];

  services.avahi.publish = {
    enable = true;
    addresses = true; # answer to server.local
  };
}
