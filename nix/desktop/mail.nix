# GENERATED from config.org ("Internet / Mail"). Do not edit; edit config.org.
# nix/desktop/mail.nix: Thunderbird; optionally work mail in Emacs (mu4e).
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  # isync with the SASL XOAUTH2 plugin, needed for Microsoft 365.
  isync = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
in
{
  options.mail.mu4e.enable = lib.mkEnableOption "work mail (Microsoft 365) in Emacs through mbsync, msmtp and mu4e";

  config = lib.mkMerge [
    {
      users.users.${username}.packages = [ pkgs.thunderbird ];
    }

    (lib.mkIf config.mail.mu4e.enable {
      users.users.${username}.packages = [
        isync # mbsync: synchronises ~/Mail with the server
        pkgs.msmtp # sends mail
        pkgs.mu # indexes ~/Mail; mu4e is its Emacs interface
        pkgs.oama # gets and renews the OAuth2 token
      ];

      dotfiles.links = {
        ".config/isyncrc" = "live/mail/isyncrc";
        ".config/msmtp/config" = "live/mail/msmtp";
        ".config/oama/config.yaml" = "live/mail/oama.yaml";
      };
      dotfiles.folders = [ "Mail/work" ];

      # Fetch mail every five minutes, then update mu's index.
      systemd.user.services.mbsync = {
        description = "Synchronise mail (mbsync) and index it (mu)";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${isync}/bin/mbsync -a";
          ExecStartPost = "${pkgs.mu}/bin/mu index";
        };
      };
      systemd.user.timers.mbsync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*:0/5";
          Persistent = true;
        };
      };
    })
  ];
}
