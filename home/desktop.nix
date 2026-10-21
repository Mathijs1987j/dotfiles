# GENERATED from config.org ("User: mathijs / Desktop session"). Do not edit; edit config.org.
# home/desktop.nix: the pieces that turn the niri compositor into a desktop.
# Each block is one job from chapter 3; swap any of them independently.
# They run as systemd user services tied to graphical-session.target, which
# niri starts, so they come and go with your session. The bar: waybar.nix.
{
  config,
  pkgs,
  ...
}:

let
  lock = "${pkgs.swaylock}/bin/swaylock -f";

  # run-or-raise APP-ID COMMAND...: focus the window of that app if one is
  # open, otherwise start the command. Used by niri's Mod+B (chapter 4.3).
  run-or-raise = pkgs.writeShellApplication {
    name = "run-or-raise";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      app="$1"; shift
      id=$(niri msg --json windows \
        | jq -r --arg app "$app" 'first(.[] | select(.app_id == $app) | .id) // empty')
      if [ -n "$id" ]; then
        niri msg action focus-window --id "$id"
      else
        exec "$@"
      fi
    '';
  };

  # power-menu: lock, suspend, log out, reboot or shut down, chosen in fuzzel.
  # Bound to Mod+X in niri.
  power-menu = pkgs.writeShellApplication {
    name = "power-menu";
    text = ''
      choice=$(printf '%s\n' lock suspend logout reboot poweroff \
        | fuzzel --dmenu --prompt "power: " --lines 5 --width 20) || exit 0
      case "$choice" in
        lock) loginctl lock-session ;;
        suspend) systemctl suspend ;;
        logout) niri msg action quit --skip-confirmation ;;
        reboot) systemctl reboot ;;
        poweroff) systemctl poweroff ;;
      esac
    '';
  };
in
{

  # niri's own settings file (keybindings, layout, input, workspaces).
  # Linked "out of store": ~/.config/niri/config.kdl points straight at the
  # file in your repository, so edits take effect on save (niri reloads it)
  # without a rebuild. Commit the file as usual.
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/niri/config.kdl";

  home.packages = with pkgs; [
    run-or-raise
    power-menu
    swaybg # wallpaper (started from niri's config)
    wl-clipboard # wl-copy / wl-paste
    libnotify # notifications
    brightnessctl # backlight keys
    playerctl # media keys
    pwvucontrol # volume mixer (PipeWire)
    satty # annotate screenshots: wl-paste | satty -f -
    wl-mirror # mirror the laptop screen to a projector (Mod+P in niri)
    jq # used by the scripts and by niri msg --json
    adwaita-icon-theme
  ];

  # ---------------------------------------------------------------- Launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty -e";
        font = "Inter:size=12";
        width = 40;
      };
      colors = {
        background = "1e1e2ef0";
        text = "cdd6f4ff";
        selection = "45475aff";
        selection-text = "cdd6f4ff";
        border = "89b4faff";
      };
    };
  };

  # ---------------------------------------------------------------- Notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 6000; # milliseconds
      border-radius = 6;
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      font = "Inter 11";
    };
  };

  # ---------------------------------------------------------------- Lock and idle
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      show-failed-attempts = true;
      indicator-caps-lock = true;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 7200; command = lock; } # 120 min: lock
      {
        timeout = 7230; # then switch the screens off
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];
    events = {
      before-sleep = lock; # lock before suspend
      lock = lock; # `loginctl lock-session` locks too
    };
  };

  # ---------------------------------------------------------------- Helpers
  services.polkit-gnome.enable = true; # "enter your password" dialogs
  services.cliphist.enable = true; # clipboard history (Mod+Shift+C in niri)
  services.network-manager-applet.enable = true; # Wi-Fi menu in the tray
  services.blueman-applet.enable = true; # Bluetooth menu in the tray
  services.udiskie = {
    enable = true; # auto-mount USB disks, with a tray icon to eject them
    tray = "auto";
  };
  services.wlsunset = {
    enable = true; # warmer screen colours in the evening
    latitude = 52.1; # roughly the centre of the Netherlands; adjust
    longitude = 5.3;
  };

  # ---------------------------------------------------------------- Look
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
