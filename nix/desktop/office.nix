# GENERATED from config.org ("Writing and teaching / Office"). Do not edit; edit config.org.
# nix/desktop/office.nix: office suite, PDF and image viewers.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    libreoffice
    papers # PDFs
    loupe # images
  ];
}
