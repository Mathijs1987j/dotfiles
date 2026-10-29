# GENERATED from config.org ("Desktop / Login screen"). Do not edit; edit config.org.
# nix/desktop/login.nix: greetd with tuigreet.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.greetd = {
    enable = true;
    useTextGreeter = true; # keep boot messages from drawing over it
    settings.default_session.command = lib.concatStringsSep " " [
      "${pkgs.tuigreet}/bin/tuigreet"
      "--time --remember --remember-session --asterisks"
      "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
      "--cmd niri-session"
    ];
  };

  # A safety-net desktop for the first weeks: uncomment, rebuild, and pick
  # "Plasma" in tuigreet (F3) if your niri setup ever leaves you stuck.
  # services.desktopManager.plasma6.enable = true;
}
