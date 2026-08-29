{ mkSystemDisk, ... }:
{
  disko.devices.disk.system = mkSystemDisk "/dev/disk/by-id/APPLE_SSD_TS128C_91UA4318K6IK";
}
