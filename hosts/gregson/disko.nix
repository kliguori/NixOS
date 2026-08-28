{ mkSystemDisk, ... }:
{
  disko.devices.disk.system =
    mkSystemDisk "/dev/disk/by-id/nvme-WDC_PC_SN730_SDBQNTY-512G-1001_195275801104";
}
