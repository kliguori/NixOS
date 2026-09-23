{ config, lib, ... }:
let
  cfg = config.systemOptions.services.forgejo;
  caddy = config.systemOptions.services.caddy;
  port = 3000;
  host = "git.${caddy.baseDomain}";
in
{
  options.systemOptions.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo git mirror";
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;

      database.type = "sqlite3";

      settings = {
        server = {
          DOMAIN = host;
          ROOT_URL = "https://${host}";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = port;

          DISABLE_SSH = true;
        };
        service.DISABLE_REGISTRATION = true;

        mirror.ENABLED = true;
        log.LEVEL = "Warn";
      };
    };

    systemOptions.apps.forgejo = {
      subdomain = "git";
      inherit port;
      title = "Forgejo";
      description = "Git mirror";
      icon = "forgejo.svg";
    };

    systemOptions.impermanence.persistDirs = [ "/var/lib/forgejo" ];
  };
}
