# GENERATED from config.org ("User: mathijs / Bar"). Do not edit; edit config.org.
# home/waybar.nix: the bar at the top of the screen. Every item is a
# "module"; the three lists below decide which ones appear, and in what
# order. Chapter 3.4 lists all modules and shows how to write your own.
{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true; # started with the niri session, restarted on crash
    settings.main = {
      layer = "top";
      position = "top";
      height = 28;

      # Workspaces only, no window titles or task list.
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "cpu"
        "memory"
        "disk"
        "temperature"
        "pulseaudio"
        "backlight"
        "network"
        "battery"
        "power-profiles-daemon"
        "tray"
      ];

      # Workspace buttons show the name of named workspaces ("web", "chat")
      # and the number of the others.
      "niri/workspaces".format = "{value}";

      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      # System information. `interval` is in seconds.
      cpu = {
        format = "cpu {usage}%";
        interval = 5;
      };
      memory = {
        format = "mem {percentage}%";
        tooltip-format = "{used:0.1f} of {total:0.1f} GiB in use, swap {swapUsed:0.1f} GiB";
        interval = 10;
      };
      disk = {
        path = "/";
        format = "disk {free} free";
        tooltip-format = "{used} of {total} used on {path} ({percentage_used}%)";
        interval = 60;
      };
      temperature = {
        # If this shows a strange value, pick the right sensor: see chapter 3.4.
        format = "{temperatureC}°C";
        critical-threshold = 85;
        interval = 10;
      };

      pulseaudio = {
        format = "vol {volume}%";
        format-muted = "vol muted";
        on-click = "pwvucontrol";
      };
      backlight.format = "light {percent}%";
      network = {
        format-wifi = "wifi {essid}";
        format-ethernet = "wired";
        format-disconnected = "offline";
        tooltip-format = "{ifname} {ipaddr}";
        on-click = "alacritty -e nmtui";
      };
      battery = {
        format = "bat {capacity}%";
        format-charging = "bat+ {capacity}%";
        states = {
          warning = 25;
          critical = 10;
        };
      };
      tray.spacing = 8;

      # A module of your own: any command's output, refreshed regularly.
      # Example, once mail is set up: unread messages in the work inbox.
      # "custom/mail" = {
      #   exec = "mu find flag:unread maildir:/work/Inbox 2>/dev/null | wc -l";
      #   format = "mail {}";
      #   interval = 120;
      # };
    };

    style = ''
      * { font-family: "Inter", "JetBrainsMono Nerd Font"; font-size: 13px; }
      window#waybar { background: rgba(30, 30, 46, 0.92); color: #cdd6f4; }
      #workspaces button { padding: 0 6px; color: #a6adc8; }
      #workspaces button.active { color: #89b4fa; border-bottom: 2px solid #89b4fa; }
      #clock, #cpu, #memory, #disk, #temperature, #pulseaudio, #backlight,
      #network, #battery, #power-profiles-daemon, #tray { padding: 0 9px; }
      #cpu, #memory, #disk, #temperature { color: #a6adc8; }
      #temperature.critical, #battery.critical { color: #f38ba8; }
      #battery.warning { color: #f9e2af; }
    '';
  };
}
