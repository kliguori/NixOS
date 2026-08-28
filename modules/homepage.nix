{ config, lib, ... }:
let
  cfg = config.systemOptions.services.homepage;
  caddy = config.systemOptions.services.caddy;

  port = 8082;

  shown = lib.filterAttrs (_n: app: app.dashboard) config.systemOptions.apps;

  url = app: "https://${if app.subdomain == "@" then caddy.baseDomain else "${app.subdomain}.${caddy.baseDomain}"}";

  categories = lib.unique (lib.mapAttrsToList (_n: app: app.category) shown);

  servicesByCategory = map (cat: {
    ${cat} = lib.mapAttrsToList (_n: app: {
      ${app.title} = {
        description = app.description;
        icon = app.icon;
        href = url app;
        siteMonitor = url app;
      };
    }) (lib.filterAttrs (_n: app: app.category == cat) shown);
  }) categories;
in
{
  options.systemOptions.services.homepage.enable = lib.mkEnableOption "Homepage dashboard";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = caddy.enable;
        message = "homepage.enable requires caddy.enable = true.";
      }
    ];

    systemOptions.apps.homepage = {
      subdomain = "@";
      inherit port;
      title = "Homepage";
      dashboard = false;
    };

    services.homepage-dashboard = {
      enable = true;
      listenPort = port;
      allowedHosts = caddy.baseDomain;
      services = servicesByCategory;
      settings = {
        headerStyle = "clean";
        statusStyle = "dot";
        hideVersion = true;
      };
    };
  };
}
