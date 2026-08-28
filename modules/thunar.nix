{ config, lib, ... }:
{
  config = lib.mkIf config.systemOptions.desktop.enable {
    programs.thunar.enable = true;
  };
}
