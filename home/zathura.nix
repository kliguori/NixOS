{ osConfig, lib, pkgs, ... }:
{
  config = lib.mkIf osConfig.systemOptions.desktop.enable {
    home.packages = [ pkgs.zathura ];
  };
}
