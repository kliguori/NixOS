{ mkSystemDisk, mkDataDisk, ... }:
{
  disko.devices.disk = {
    system = mkSystemDisk "/dev/disk/by-id/PLACEHOLDER-SYSTEM-128GB-SSD";

    data = mkDataDisk {
      device = "/dev/disk/by-id/PLACEHOLDER-DATA-4TB-NVME";
      name = "data";
      label = "media";
      mountpoint = "/data";
    };
  };
}
