{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.systemOptions.claude-vm;
  stateDir = "${config.users.users.kevin.home}/tank/.claude-vm";

  pythonEnv = pkgs.python312.withPackages (
    ps: with ps; [
      sympy
      numpy
      scipy
      matplotlib
      ipython
      black
      flake8
    ]
  );

in
{
  imports = [ inputs.microvm.nixosModules.host ];

  options.systemOptions.claude-vm = {
    enable = lib.mkEnableOption "Sandboxed claude-code microVM";

    workspace = lib.mkOption {
      type = lib.types.str;
      default = "${config.users.users.kevin.home}/tank/projects";
      description = "Host directory shared into the guest at /workspace.";
    };

    mem = lib.mkOption {
      type = lib.types.int;
      default = 8192;
      description = "Memory ceiling in MiB. Never use exactly 2048.";
    };

    vcpu = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Virtual CPUs.";
    };
  };

  config = lib.mkIf cfg.enable {
    microvm = {
      host.enable = true;
      autostart = [ ];
      vms.claude = {
        config = {
          system.stateVersion = "26.05";

          microvm = {
            hypervisor = "qemu";
            mem = cfg.mem;
            balloon = true;
            vcpu = cfg.vcpu;

            forwardPorts = [
              {
                from = "host";
                host.port = 2222;
                guest.port = 22;
              }
            ];

            interfaces = [
              {
                type = "user";
                id = "vm-claude";
                mac = "02:00:00:00:00:01";
              }
            ];

            volumes = [
              {
                image = "root.img";
                mountPoint = "/";
                size = 8192;
              }
            ];

            shares = [
              {
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }
              {
                source = cfg.workspace;
                mountPoint = "/workspace";
                tag = "workspace";
                proto = "virtiofs";
              }
              {
                source = "${stateDir}/home";
                mountPoint = "/home/kevin";
                tag = "home";
                proto = "virtiofs";
              }
            ];
          };

          networking = {
            hostName = "claude";
            useDHCP = true;
            firewall = {
              enable = true;
              allowedTCPPorts = [ 22 ];
            };
          };

          users = {
            mutableUsers = false;
            users.kevin = {
              isNormalUser = true;
              uid = 1000;
              home = "/home/kevin";
              extraGroups = [ "wheel" ];
              hashedPassword = "";
              openssh.authorizedKeys.keys = config.users.users.kevin.openssh.authorizedKeys.keys;
              shell = pkgs.zsh;
            };
          };

          security.sudo.wheelNeedsPassword = false;
          programs.zsh.enable = true;
          services = {
            getty.autologinUser = "kevin";
            openssh = {
              enable = true;
              settings = {
                PermitRootLogin = "no";
                PasswordAuthentication = false;
              };
            };
          };

          environment = {
            sessionVariables.WORKSPACE = "/workspace";
            systemPackages = with pkgs; [
              claude-code
              pythonEnv
              texliveFull
              git
              neovim
              ripgrep
              fd
            ];
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0700 kevin users -"
      "d ${stateDir}/home 0700 kevin users -"
    ];

    environment.shellAliases.claude = ''
      ssh -t -p 2222 kevin@localhost "cd /workspace && exec claude"
    '';
  };
}
