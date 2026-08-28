{ lib }:
{
  mkSystemDisk = device: {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "2G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
            extraArgs = [
              "-n"
              "ESP"
            ];
          };
        };

        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            passwordFile = "/tmp/luks.key";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "system"
              ];
              subvolumes = {
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "discard=async"
                  ];
                };
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "discard=async"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };

  mkDataDisk =
    {
      device,
      name,
      label,
      mountpoint,
      ssd ? true,
      compress ? (if ssd then "zstd:1" else "zstd:3"),
    }:
    {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions.${name} = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypt${name}";
            passwordFile = "/tmp/luks.key";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                label
              ];
              inherit mountpoint;
              mountOptions = [
                "noatime"
                "compress=${compress}"
              ]
              ++ lib.optionals ssd [ "discard=async" ];
            };
          }
          // lib.optionalAttrs ssd { settings.allowDiscards = true; };
        };
      };
    };
}
