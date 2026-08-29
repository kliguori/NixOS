{
  description = "One config to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hibi = {
      url = "github:kliguori/hibi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      myLib = import ./lib { inherit lib; };
      hosts = {
        sherlock = {
          hardware = [
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-pc
          ];
          tags = [ "desktop" ];
        };
        gregson = {
          hardware = [
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-pc-laptop
          ];
          tags = [
            "desktop"
            "laptop"
          ];
        };
        hudson = {
          hardware = [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nixos-hardware.nixosModules.common-pc
          ];
          tags = [ "server" ];
        };
        jones = {
          hardware = [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nixos-hardware.nixosModules.common-pc-laptop
          ];
          tags = [
            "desktop"
            "laptop"
          ];
        };
      };

      vms = {
        claude = { };
      };

      baseModules =
        hostName: host:
        [
          ./hosts/${hostName}
          ./modules
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs hostName;
              }
              // myLib;
            };
          }
        ]
        ++ host.hardware;

      mkHost =
        hostName: host:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName;
          }
          // myLib;
          modules = baseModules hostName host;
        };

      mkVm =
        name: _:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            inputs.microvm.nixosModules.microvm
            ./vms/${name}.nix
          ];
        };

    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      packages.${system} = {
        install-host = pkgs.writeShellApplication {
          name = "install-host";
          runtimeInputs = [
            inputs.nixos-anywhere.packages.${system}.default
            pkgs.openssh
            pkgs.coreutils
          ];
          text = ''
            FLAKE="''${1:?usage: install-host <flake#host> <ip> <age-key-file>}"
            IP="''${2:?usage: install-host <flake#host> <ip> <age-key-file>}"
            KEY="''${3:?usage: install-host <flake#host> <ip> <age-key-file>}"

            HOST="''${FLAKE##*#}"
            if [ "$HOST" = "$FLAKE" ]; then
              echo "flake must include #<host>, e.g. .#jones" >&2
              exit 1
            fi

            TMP=$(mktemp -d)
            trap 'rm -rf "$TMP"' EXIT

            read -rs -p "LUKS passphrase for $HOST: " LUKS
            echo
            printf '%s' "$LUKS" > "$TMP/luks.key"

            install -Dm600 "$KEY" "$TMP/extra/persist/sops/$HOST.key"

            echo "installing $HOST from $FLAKE"

            nixos-anywhere \
              --flake "$FLAKE" \
              --disk-encryption-keys /tmp/luks.key "$TMP/luks.key" \
              --extra-files "$TMP/extra" \
              "root@$IP"
          '';
        };
      };

      nixosConfigurations = lib.mapAttrs mkHost hosts // lib.mapAttrs mkVm vms;

      colmenaHive = inputs.colmena.lib.makeHive (
        {
          meta = {
            nixpkgs = import nixpkgs { inherit system; };
            specialArgs = {
              inherit inputs;
            }
            // myLib;
            nodeSpecialArgs = lib.mapAttrs (hostName: _: { inherit hostName; }) hosts;
          };
        }
        // lib.mapAttrs (hostName: host: {
          imports = baseModules hostName host;
          deployment = {
            targetHost = hostName;
            targetUser = "root";
            inherit (host) tags;
          };
        }) hosts
      );
    };
}
