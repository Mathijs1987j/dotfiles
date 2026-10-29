# GENERATED from config.org ("Files and disks"). Do not edit; edit config.org.
# nix/desktop/files.nix: file manager, disks, keyring viewer.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    nautilus
    gnome-disk-utility # "Disks": format drives, check health
    seahorse # view the keyring: passwords, SSH keys
  ];

  # The standard folders, and the file that names them for programs.
  dotfiles.folders = [ "Desktop" "Documents" "Downloads" "Music" "Pictures"
                       "Public" "Templates" "Videos" ];
  dotfiles.links.".config/user-dirs.dirs" = "live/xdg/user-dirs.dirs";
}
