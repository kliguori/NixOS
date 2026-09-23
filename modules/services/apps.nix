{ lib, ... }:
{
  options.systemOptions.apps = lib.mkOption {
    default = { };
    description = "Web apps to reverse-proxy and show on the dashboard.";
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            subdomain = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = "Host is <subdomain>.<baseDomain>. Use \"@\" for the bare domain.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              description = "Localhost port the app listens on.";
            };

            title = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = "Display name on the dashboard.";
            };

            description = lib.mkOption {
              type = lib.types.str;
              default = "";
            };

            icon = lib.mkOption {
              type = lib.types.str;
              default = "${name}.svg";
            };

            category = lib.mkOption {
              type = lib.types.str;
              default = "Services";
            };

            dashboard = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Show a tile for this app on the dashboard.";
            };
          };
        }
      )
    );
  };
}
