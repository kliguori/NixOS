{ ... }:
{
  imports = [ ./disko.nix ];

  system.stateVersion = "26.05";

  fileSystems."/data".neededForBoot = true;

  systemOptions = {
    impermanence.rootTmpfsSize = "4G";

    services = {
      caddy.enable = true;
      homepage.enable = true;
      jellyfin.enable = true;
      audiobookshelf.enable = true;
      vaultwarden.enable = true;
      forgejo.enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/media            0775 root media - -"
    "d /data/media/movies     0775 root media - -"
    "d /data/media/tv         0775 root media - -"
    "d /data/media/audiobooks 0775 root media - -"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/nix"
      "/data"
    ];
    interval = "monthly";
  };

  services.smartd = {
    enable = true;
    notifications.wall.enable = true;
  };

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-routes=10.54.1.0/24" ];
  };
}
