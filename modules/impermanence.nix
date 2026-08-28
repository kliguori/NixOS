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
      description = ''
        Where OS state is kept. Its own filesystem, deliberately NOT inside
        /nix: the store is a reproducible cache that nix-collect-garbage and
        nix store optimise operate on, and this is the only copy of the
        machine's identity.
      '';
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
      description = ''
        Directories under the primary user's home that survive a reboot,
        relative to it.

        /home is ephemeral like /, so this list is the whole of what is kept.
        Keep it short and deliberate: the point of an ephemeral home is that
        an application cannot accumulate state you did not choose to keep.

        This module deliberately does NOT know whose home it is -- it owns the
        concept of persistence, and modules/user.nix owns the account.
        That is also why the list is not an attrset keyed by username: there is
        exactly one human, and pretending otherwise would be generality that
        every consumer here immediately breaks.
      '';
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
