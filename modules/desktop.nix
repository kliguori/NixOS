{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.systemOptions.desktop.enable = lib.mkEnableOption "Graphical desktop environment";

  config = lib.mkIf config.systemOptions.desktop.enable {
    programs = {
      niri.enable = true;
      dms-shell.enable = true;
      thunar.enable = true;
    };

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        xdg-utils
        wl-clipboard
        xwayland-satellite
      ];
    };
  };
}
