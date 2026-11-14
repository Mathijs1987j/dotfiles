# GENERATED from config.org ("Desktop / Reaching the server"). Do not edit; edit config.org.
# nix/desktop/server-access.nix: SSH settings and deploy-server.
{ ... }:

{
  dotfiles.links = {
    ".ssh/config" = "live/ssh/config";
    ".local/bin/deploy-server" = "live/bin/deploy-server";
  };
}
