# GENERATED from config.org ("Media and music"). Do not edit; edit config.org.
# nix/desktop/media.nix: music, video, scores.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
    spotify
    mpv # video
    yt-dlp # downloads; also used by mpv for links
    musescore
    shotcut
  ];
}
