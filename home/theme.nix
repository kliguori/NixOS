{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.theme = {
    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
    fonts = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 12;
      };
    };
  };

  config = {
    home.packages = lib.mkIf osConfig.systemOptions.desktop.enable (
      with pkgs;
      [
        fira-code
        nerd-fonts.jetbrains-mono
      ]
    );

    theme.colors =
      let
        base = {
          background = "#1F1F28";
          foreground = "#DCD7BA";
          selection = "#2D4F67";
          comment = "#727169";
          cyan = "#7AA89F";
          green = "#98BB6C";
          orange = "#FFA066";
          pink = "#D27E99";
          purple = "#957FB8";
          red = "#E82424";
          yellow = "#E6C384";
          currentLine = "#2A2A37";
          blue = "#7E9CD8";
        };
        toRgb = lib.mapAttrs' (n: v: lib.nameValuePair "${n}Rgb" (lib.removePrefix "#" v));
      in
      base // toRgb base;
  };
}
