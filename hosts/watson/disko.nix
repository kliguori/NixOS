{ mkSystemDisk, ... }:
{
  disko.devices.disk.system = mkSystemDisk "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
}
