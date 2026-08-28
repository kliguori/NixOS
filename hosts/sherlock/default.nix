{ pkgs, ... }:
{
  imports = [ ./disko.nix ];

  system.stateVersion = "26.05";

  boot.kernelModules = [ "sg" ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/nix"
      "/data"
      "/data/scratch"
    ];
    interval = "monthly";
  };

  services.smartd = {
    enable = true;
    notifications.wall.enable = true;
  };

  fileSystems."/data".neededForBoot = true;

  systemOptions = {
    desktop.enable = true;

    impermanence.persistUserDirs = [ ".MakeMKV" ];
    nvidia = {
      enable = true;
      prime.enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    android-tools
    makemkv
    (handbrake.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/ghb \
          --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
      '';
    }))
  ];
}
