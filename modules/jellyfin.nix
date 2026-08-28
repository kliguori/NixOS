{ config, lib, ... }:
let
  cfg = config.systemOptions.services.jellyfin;
in
{
  options.systemOptions.services.jellyfin.enable = lib.mkEnableOption "Jellyfin media server";

  config = lib.mkIf cfg.enable {
    services.jellyfin.enable = true;

    systemOptions.apps.jellyfin = {
      port = 8096;
      title = "Jellyfin";
      description = "Movies and TV";
      icon = "jellyfin.svg";
      category = "Media";
    };

    systemOptions.impermanence.persistDirs = [ "/var/lib/jellyfin" ];

    systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/data/media";

    users.groups.media = { };
    users.users.jellyfin.extraGroups = [ "media" ];
  };
}
