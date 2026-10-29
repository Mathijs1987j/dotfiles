# GENERATED from config.org ("Internet / LibreWolf"). Do not edit; edit config.org.
# nix/desktop/browser.nix: LibreWolf, Firefox as fallback, default programs.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = [ pkgs.librewolf ];
  programs.firefox.enable = true; # the fallback browser, system-wide

  # Which programs open links and files (your own choices, made in a
  # program's "open with" dialog, take precedence).
  xdg.mime.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "application/pdf" = "org.gnome.Papers.desktop";
    "image/png" = "org.gnome.Loupe.desktop";
    "image/jpeg" = "org.gnome.Loupe.desktop";
    "inode/directory" = "org.gnome.Nautilus.desktop";
  };

  # LibreWolf reads its overrides from the folder its profiles are in. New
  # installations use the XDG layout (~/.config/librewolf/librewolf/), older
  # ones ~/.librewolf/; on the stick the old place was silently ignored
  # (resistFingerprinting stayed on). The same file goes to both.
  dotfiles.links = {
    ".config/librewolf/librewolf/librewolf.overrides.cfg" = "live/librewolf/librewolf.overrides.cfg";
    ".librewolf/librewolf.overrides.cfg" = "live/librewolf/librewolf.overrides.cfg";
  };
}
