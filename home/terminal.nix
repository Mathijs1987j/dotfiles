# GENERATED from config.org ("User: mathijs / Terminals"). Do not edit; edit config.org.
# home/terminal.nix: terminal emulators. Alacritty is the default (Mod+T);
# foot stays installed for comparison (Mod+Shift+T). Chapter 7.4.
{ ... }:

let
  font = "JetBrainsMono Nerd Font";
  # Catppuccin Mocha colours, the same palette as the bar and launcher.
  c = {
    base = "#1e1e2e";
    text = "#cdd6f4";
    surface = "#45475a";
    subtext = "#a6adc8";
    red = "#f38ba8";
    green = "#a6e3a1";
    yellow = "#f9e2af";
    blue = "#89b4fa";
    pink = "#f5c2e7";
    teal = "#94e2d5";
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = font;
      font.size = 11;
      window.padding = {
        x = 6;
        y = 4;
      };
      scrolling.history = 20000;
      mouse.hide_when_typing = true;
      colors = {
        primary = {
          background = c.base;
          foreground = c.text;
        };
        normal = {
          black = c.surface;
          red = c.red;
          green = c.green;
          yellow = c.yellow;
          blue = c.blue;
          magenta = c.pink;
          cyan = c.teal;
          white = c.subtext;
        };
        bright = {
          black = "#585b70";
          red = c.red;
          green = c.green;
          yellow = c.yellow;
          blue = c.blue;
          magenta = c.pink;
          cyan = c.teal;
          white = c.text;
        };
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main.font = "${font}:size=11";
      main.pad = "6x4";
      mouse.hide-when-typing = "yes";
      scrollback.lines = 20000;
      colors-dark = {
        background = "1e1e2e";
        foreground = "cdd6f4";
      };
    };
  };
}
