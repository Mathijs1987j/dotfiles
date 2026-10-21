# GENERATED from config.org ("User: mathijs / Browser"). Do not edit; edit config.org.
# home/browser.nix: LibreWolf, and which programs open links and files.
{ config, ... }:

{
  # ---------------------------------------------------------------- LibreWolf
  # Chapter 17. These settings go into ~/.librewolf/librewolf.overrides.cfg
  # and soften the defaults that most often get in the way. They apply to
  # every LibreWolf profile, including WhatsApp's (apps.nix).
  programs.librewolf = {
    enable = true;
    settings = {
      # Keep cookies and logins when the browser closes (history is still
      # cleared). Sites stay logged in: Outlook web, GitHub, school portals.
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown.cookies" = false;
      # resistFingerprinting forces a light theme, reports the time zone as
      # UTC and makes some sites misbehave. Firefox's milder fingerprinting
      # protection stays on instead. Set to true for maximum privacy.
      "privacy.resistFingerprinting" = false;
      "privacy.fingerprintingProtection" = true;
      # Allow WebGL (maps, GeoGebra, some reveal.js decks) without a prompt.
      "webgl.disabled" = false;
      # Firefox Sync is off by default in LibreWolf; uncomment to use it.
      # "identity.fxaccounts.enabled" = true;
    };
  };

     # Home Manager writes the settings above to ~/.librewolf/, but LibreWolf
     # now keeps its profiles in ~/.config/librewolf/librewolf/ (the XDG layout)
     # and reads the overrides file from that folder. Put the same file there.
     xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source =
       config.home.file.".librewolf/librewolf.overrides.cfg".source;

  # Default applications for links and files.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
