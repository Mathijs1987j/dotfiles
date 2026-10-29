# GENERATED from config.org ("Every machine / Your account"). Do not edit; edit config.org.
# nix/core/users.nix: your account.
{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Mathijs";
    extraGroups = [
      "wheel" # may use sudo
      "networkmanager" # may change network settings
      "video" # backlight control
    ];
    initialPassword = "changeme"; # first login only; then `passwd`
  };
}
