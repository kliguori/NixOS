{ pkgs, ... }:
{
  imports = [ ./disko.nix ];

  system.stateVersion = "26.05";

  systemOptions = {
    desktop.enable = true;
    claude-vm.enable = true;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # --- Force Wayland to use Intel GPU ---
  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1"; # card1 is intel card0 nvidia
  };

  # --- Set profile to "cool" ---
  systemd.services.set-platform-profile = {
    description = "Set Dell platform profile to cool";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "echo cool > /sys/firmware/acpi/platform_profile"
      '';
    };
  };

  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/nix" ];
      interval = "monthly";
    };
    smartd = {
      enable = true;
      notifications.wall.enable = true;
    };
  };
}
