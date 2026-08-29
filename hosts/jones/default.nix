{ ... }:
{
  imports = [ ./disko.nix ];

  system.stateVersion = "26.05";

  systemOptions = {
    desktop.enable = true;
    impermanence.rootTmpfsSize = "4G";
  };

  boot.blacklistedKernelModules = [
    "b43"
    "bcma"
    "brcmsmac"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/nix" ];
    interval = "monthly";
  };

  services.smartd = {
    enable = true;
    notifications.wall.enable = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
