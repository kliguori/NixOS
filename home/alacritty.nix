{
  config,
  osConfig,
  lib,
  ...
}:
let
  c = config.theme.colors;
  f = config.theme.fonts;
in
{
  config = lib.mkIf osConfig.systemOptions.desktop.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = f.mono;
          size = f.size;
        };
        window.opacity = 0.75;
        colors = {
          primary = {
            foreground = c.foreground;
            background = c.background;
          };
          cursor = {
            text = c.background;
            cursor = c.foreground;
          };
          selection = {
            text = c.foreground;
            background = c.selection;
          };
          normal = {
            black = "#21222c";
            red = c.red;
            green = c.green;
            yellow = c.yellow;
            blue = c.purple;
            magenta = c.pink;
            cyan = c.cyan;
            white = "#f8f8f2";
          };
          bright = {
            black = c.selection;
            red = c.red;
            green = c.green;
            yellow = c.yellow;
            blue = c.purple;
            magenta = c.pink;
            cyan = c.cyan;
            white = "#ffffff";
          };
        };
      };
    };
  };
}
