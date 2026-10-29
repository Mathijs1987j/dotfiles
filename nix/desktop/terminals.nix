# GENERATED from config.org ("Desktop / Terminals"). Do not edit; edit config.org.
# nix/desktop/terminals.nix: Alacritty (default) and foot.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    alacritty
    foot
  ];
  dotfiles.links = {
    ".config/alacritty/alacritty.toml" = "live/alacritty/alacritty.toml";
    ".config/foot/foot.ini" = "live/foot/foot.ini";
  };
}
