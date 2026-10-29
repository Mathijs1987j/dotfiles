# GENERATED from config.org ("Internet / Signal"). Do not edit; edit config.org.
# nix/desktop/signal.nix: Signal.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = [ pkgs.signal-desktop ];
}
