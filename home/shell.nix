# GENERATED from config.org ("User: mathijs / Shell"). Do not edit; edit config.org.
# home/shell.nix: the shell and everything you use from it. Chapters 4, 7, 14, 15.
{ pkgs, ... }:

{

  # ---------------------------------------------------------------- Bash
  programs.bash = {
    enable = true; # Home Manager writes ~/.bashrc, so the settings below apply
    historySize = 20000;
    historyControl = [ "ignoredups" "erasedups" ];
    shellOptions = [ "histappend" "autocd" "globstar" "checkwinsize" ];

    # Aliases: short names for longer commands (chapter 4.6).
    shellAliases = {
      # NixOS
      rebuild = "nh os switch"; # build and switch to the new configuration
      rebuild-boot = "nh os boot"; # build; use it from the next boot on
      update = "nh os switch --update"; # update flake.lock, then switch
      gens = "nh os info"; # list generations
      # The configuration (chapter 20)
      cfg = "emacsclient -n ~/dotfiles/config.org"; # open config.org in Emacs
      # Everyday
      ll = "ls -lh --group-directories-first --color=auto";
      la = "ls -lAh --group-directories-first --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      e = "emacsclient -n"; # open a file in the running Emacs
      dots = "cd ~/dotfiles";
      # Git
      gs = "git status";
      gl = "git log --oneline --graph --decorate -20";
      # Disks
      dfh = "df -h -x tmpfs -x devtmpfs -x efivarfs";
    };

    # Small shell functions, for things an alias cannot do.
    initExtra = ''
      # mkcd DIR: make a folder and go into it
      mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
      # nwhy PKG: why is PKG part of the current system? (chapter 14)
      nwhy() { nix why-depends /run/current-system "$(nix eval --raw "nixpkgs#$1.outPath")"; }
    '';
  };

  programs.starship.enable = true; # informative prompt (git branch, venv, ...)
  programs.fzf.enable = true; # Ctrl-R history, Ctrl-T files, Alt-C folders
  programs.zoxide.enable = true; # `z dotf` jumps to ~/dotfiles
  programs.direnv = {
    enable = true; # per-project environments (.envrc); envrc in Emacs uses it
    nix-direnv.enable = true;
  };

  # ---------------------------------------------------------------- Git and GitHub
  programs.git = {
    enable = true;
    settings = {
      user.name = "Mathijs";
      # Your PERSONAL address (or GitHub's private noreply address), not the
      # work address. Chapter 15.
      user.email = "mathijsjanssenecon@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
  # GitHub's command-line tool: `gh auth login` once, after which git can
  # push over HTTPS with the token gh keeps (chapters 12 and 15).
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # ---------------------------------------------------------------- tmux (chapter 5)
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "emacs";
    terminal = "tmux-256color";
    historyLimit = 20000;
  };

  # ---------------------------------------------------------------- Nix helpers (chapter 14)
  # nix-index with a weekly prebuilt database, and comma: `, cowsay hi` runs a
  # program without installing it. Also suggests packages for unknown commands.
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    nix-tree # browse what the system consists of, and why
    nix-du # graph of what takes space in the store
    graphviz # `dot`, to draw nix-du's graph

    # tangle: write every generated file from ~/dotfiles/config.org, without
    # opening Emacs (the same as saving config.org in Emacs). Chapter 20.
    (writeShellScriptBin "tangle-config" ''
      exec emacs --batch --eval "(progn (require 'org) (setq org-src-preserve-indentation t) (let ((coding-system-for-write 'utf-8-unix)) (org-babel-tangle-file \"$HOME/dotfiles/config.org\")))"
    '')

    # Terminal tools
    ripgrep
    fd
    jq
    btop
    fastfetch
    tealdeer # `tldr tar`: short examples
    yazi # terminal file manager
    powertop # what uses power (chapter 9.6)
  ];
}
