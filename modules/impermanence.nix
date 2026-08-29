{ config, lib, ... }:
let
  cfg = config.systemOptions.impermanence;
in
{
  options.systemOptions.impermanence = {
    rootTmpfsSize = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "Size of the tmpfs root. Anything written to / eats RAM.";
    };

    persistRoot = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Where OS state is kept.";
    };

    persistDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Directories bind-mounted back from persistRoot.";
    };

    persistFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    persistUserDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Persisted user directories.";
    };

    persistUserFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    fileSystems = {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "mode=0755"
          "size=${cfg.rootTmpfsSize}"
        ];
      };

      "/nix".neededForBoot = true;
      ${cfg.persistRoot}.neededForBoot = true;
    };

    systemOptions.impermanence.persistDirs = [
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd"
    ];

    systemOptions.impermanence.persistFiles = [
      "/etc/machine-id"
    ];

    systemOptions.impermanence.persistUserDirs = [
      "tank"
      ".ssh"
    ];

    environment.persistence.${cfg.persistRoot} = {
      hideMounts = true;
      directories = cfg.persistDirs;
      files = cfg.persistFiles;
    };
  };
}
