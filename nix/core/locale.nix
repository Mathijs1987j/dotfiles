# GENERATED from config.org ("Every machine / Locale and keyboard"). Do not edit; edit config.org.
# nix/core/locale.nix: time zone, languages, keyboard.
{ ... }:

{
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_IE.UTF-8"; # English names, 24-hour clock, day-month order
    LC_PAPER = "nl_NL.UTF-8"; # A4
    LC_MEASUREMENT = "nl_NL.UTF-8"; # metric
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
  console.useXkbConfig = true; # the same on the text console
}
