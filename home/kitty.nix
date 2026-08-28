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
    programs.kitty = {
      enable = true;
      font = {
        name = f.mono;
        size = f.size;
      };
      settings = {
        background_opacity = "0.95";
        dynamic_background_opacity = "yes";
        foreground = c.foreground;
        background = c.background;
        selection_foreground = c.foreground;
        selection_background = c.selection;
        cursor = c.foreground;
        cursor_text_color = c.background;
        url_color = c.cyan;
        color0 = "#21222c";
        color8 = c.selection;
        color1 = c.red;
        color9 = c.red;
        color2 = c.green;
        color10 = c.green;
        color3 = c.yellow;
        color11 = c.yellow;
        color4 = c.purple;
        color12 = c.purple;
        color5 = c.pink;
        color13 = c.pink;
        color6 = c.cyan;
        color14 = c.cyan;
        color7 = "#f8f8f2";
        color15 = "#ffffff";
        active_tab_foreground = c.background;
        active_tab_background = c.purple;
        inactive_tab_foreground = c.foreground;
        inactive_tab_background = c.selection;
      };
    };
  };
}
