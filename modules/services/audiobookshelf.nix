{ config, lib, ... }:
let
  cfg = config.systemOptions.services.audiobookshelf;
  port = 8000;
in
{
  options.systemOptions.services.audiobookshelf.enable =
    lib.mkEnableOption "Audiobookshelf audiobook server";

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      inherit port;
      host = "127.0.0.1";
    };

    systemOptions.apps.audiobookshelf = {
      inherit port;
      title = "Audiobookshelf";
      description = "Audiobooks and podcasts";
      icon = "audiobookshelf.svg";
      category = "Media";
    };

    systemOptions.impermanence.persistDirs = [ "/var/lib/audiobookshelf" ];

    systemd.services.audiobookshelf.unitConfig.RequiresMountsFor = "/data/media";

    users.groups.media = { };
    users.users.audiobookshelf.extraGroups = [ "media" ];
  };
}
