{ mkSystemDisk, mkDataDisk, ... }:
{
  disko.devices.disk = {
    system = mkSystemDisk "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HBJQ-000L7_S4ENNX1R291121";

    data = mkDataDisk {
      device = "/dev/disk/by-id/nvme-Micron_2300_NVMe_512GB__202829753D71";
      name = "data";
      label = "data";
      mountpoint = "/data";
    };

    scratch = mkDataDisk {
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y2YL5RAD";
      name = "scratch";
      label = "scratch";
      mountpoint = "/data/scratch";
      ssd = false;
    };
  };
}
