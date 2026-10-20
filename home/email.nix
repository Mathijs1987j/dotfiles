# GENERATED from config.org ("User: mathijs / E-mail"). Do not edit; edit config.org.
# home/email.nix: work mail (Microsoft 365) in Emacs, without DavMail.
#   oama   - gets and renews the OAuth2 token after one browser login
#   mbsync - synchronises the mailbox to ~/Mail over IMAP (XOAUTH2)
#   msmtp  - sends mail over SMTP (XOAUTH2)
#   mu     - indexes ~/Mail; mu4e is its Emacs interface
# Enable it by uncommenting ./email.nix in home.nix, after reading chapter 1:
# the school's Microsoft 365 tenant must allow IMAP/SMTP for your account and
# the OAuth client ID you use. Check with IT before relying on it. The
# sign-in itself (SURFconext, tiqr) happens once in the browser (chapter 1.3).
{ config, pkgs, ... }:

let
  address = "m.janssen@uva.nl"; # your work address
in
{
  home.packages = [ pkgs.oama ];

  # oama's settings. Replace CLIENT-ID with the ID of an app registration
  # your tenant allows (see chapter 1). Tokens are kept in gnome-keyring.
  xdg.configFile."oama/config.yaml".text = ''
    encryption:
      tag: KEYRING
    services:
      microsoft:
        client_id: CLIENT-ID
  '';

  accounts.email = {
    maildirBasePath = "Mail";
    accounts.work = {
      primary = true;
      inherit address;
      userName = address;
      realName = "Mathijs";
      flavor = "outlook.office365.com"; # IMAP and SMTP server settings
      passwordCommand = "${pkgs.oama}/bin/oama access ${address}";

      mbsync = {
        enable = true;
        create = "maildir"; # create folders locally that exist on the server
        expunge = "both";
        extraConfig.account.AuthMechs = "XOAUTH2";
      };
      msmtp = {
        enable = true;
        extraConfig.auth = "xoauth2";
      };
      mu.enable = true;
    };
  };

  programs.mbsync = {
    enable = true;
    # isync with the SASL XOAUTH2 plugin, needed for Microsoft 365
    package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
  };
  programs.msmtp.enable = true;
  programs.mu.enable = true;

  # Fetch mail every 5 minutes, then update mu's index.
  services.mbsync = {
    enable = true;
    package = config.programs.mbsync.package;
    frequency = "*:0/5";
    postExec = "${pkgs.mu}/bin/mu index";
  };
}
