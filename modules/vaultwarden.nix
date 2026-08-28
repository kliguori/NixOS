{ config, lib, ... }:
let
  cfg = config.systemOptions.services.vaultwarden;
  caddy = config.systemOptions.services.caddy;
  port = 8222;
  host = "vault.${caddy.baseDomain}";
in
{
  options.systemOptions.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden password manager";

    signupsAllowed = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;

      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        DOMAIN = "https://${host}";
        SIGNUPS_ALLOWED = cfg.signupsAllowed;
        EXTENDED_LOGGING = true;
        LOG_LEVEL = "warn";
      };
    };

    systemOptions.apps.vaultwarden = {
      subdomain = "vault";
      inherit port;
      title = "Vaultwarden";
      description = "Password manager";
      icon = "vaultwarden.svg";
    };

    systemOptions.impermanence.persistDirs = [ "/var/lib/vaultwarden" ];
  };
}
