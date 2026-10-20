# GENERATED from config.org ("User: mathijs / Entry point"). Do not edit; edit config.org.
# home/home.nix: Home Manager, your user level. Everything below belongs to
# you alone: programs in your profile, files in your home folder (~/.config)
# and user services (systemctl --user). This file only names the topic
# files; each of them is a module that is merged with the others.
{ ... }:

{
  imports = [
    ./shell.nix # bash, prompt, aliases, git, tmux, command-line tools
    ./terminal.nix # Alacritty (default) and foot
    ./apps.nix # applications, WhatsApp Web
    ./browser.nix # LibreWolf and default apps
    ./dev.nix # Python (uv), language servers, LaTeX
    ./emacs.nix # Emacs 31 with your packages, the daemon
    ./desktop.nix # niri session: launcher, notifications, lock, idle, look
    ./waybar.nix # the bar
    # ./email.nix # Microsoft 365 mail in mu4e; read chapter 1 before enabling
  ];

  # home.username and home.homeDirectory are filled in by NixOS from
  # users.users.<name>, so the same files work for a second account.

  xdg.enable = true;
  xdg.userDirs = {
    enable = true; # ~/Documents, ~/Downloads, ~/Pictures, ...
    createDirectories = true;
  };

  # Let Home Manager manage itself (needed for `home-manager` commands).
  programs.home-manager.enable = true;

  # The Home Manager release you started with. Never change it.
  home.stateVersion = "26.05";
}
