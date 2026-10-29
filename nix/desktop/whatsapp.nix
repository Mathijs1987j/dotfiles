# GENERATED from config.org ("Internet / WhatsApp Web"). Do not edit; edit config.org.
# nix/desktop/whatsapp.nix: the whatsapp-web command and its launcher entry.
{ ... }:

{
  dotfiles.links = {
    ".local/bin/whatsapp-web" = "live/bin/whatsapp-web";
    ".local/share/applications/whatsapp-web.desktop" = "live/applications/whatsapp-web.desktop";
  };
}
