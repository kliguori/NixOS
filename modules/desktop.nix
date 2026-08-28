{ config, lib, pkgs, ... }:
{
  options.systemOptions.desktop.enable = lib.mkEnableOption "Graphical desktop environment";

  config = lib.mkIf config.systemOptions.desktop.enable {
    programs.niri.enable = true;
    programs.dms-shell.enable = true;

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      xdg-utils
      wl-clipboard
      xwayland-satellite
    ];
  };
}
