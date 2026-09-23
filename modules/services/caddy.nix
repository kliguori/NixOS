{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemOptions.services.caddy;
  apps = config.systemOptions.apps;

  fqdn = app: if app.subdomain == "@" then cfg.baseDomain else "${app.subdomain}.${cfg.baseDomain}";
in
{
  options.systemOptions.services.caddy = {
    enable = lib.mkEnableOption "Caddy reverse proxy with ACME DNS-01";

    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "liguorihome.com";
    };

    cloudflareEnvFile = lib.mkOption {
      type = lib.types.str;
      default = "/persist/secrets/cloudflare/cloudflare-dns.env";
      description = ''
        File containing CF_DNS_API_TOKEN=<token>. Placed by hand at install
        time -- it is the only secret on the machine that is not in this repo.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      globalConfig = ''
        acme_dns cloudflare {env.CF_DNS_API_TOKEN}
      '';

      virtualHosts = lib.mapAttrs' (
        _name: app:
        lib.nameValuePair (fqdn app) {
          extraConfig = "reverse_proxy 127.0.0.1:${toString app.port}";
        }
      ) apps;
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = cfg.cloudflareEnvFile;

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemOptions.impermanence.persistDirs = [
      "/var/lib/caddy"
    ];
  };
}
