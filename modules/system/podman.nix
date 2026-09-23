{ config, lib, ... }:
{
  config = lib.mkIf config.systemOptions.desktop.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    systemOptions.impermanence.persistDirs = [ "/var/lib/containers" ];
    systemOptions.impermanence.persistUserDirs = [ ".local/share/containers" ];
  };
}
