{ pkgs, ... }:
{
  system.stateVersion = "26.05";

  microvm = {
    hypervisor = "qemu";
    mem = 8192;
    vcpu = 4;

    interfaces = [
      {
        type = "user";
        id = "vm-claude";
        mac = "02:00:00:00:00:01";
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
        source = "/home/kevin/tank/projects";
        mountPoint = "/workspace";
        tag = "workspace";
        proto = "virtiofs";
      }
      {
        source = "/home/kevin/tank/.claude-vm";
        mountPoint = "/home/kevin/.claude";
        tag = "claude-state";
        proto = "virtiofs";
      }
    ];
  };

  networking = {
    hostName = "claude";
    useDHCP = true;
    firewall.enable = false;
  };

  users = {
    mutableUsers = false;
    users.kevin = {
      isNormalUser = true;
      home = "/home/kevin";
      extraGroups = [ "wheel" ];
      password = "";
      shell = pkgs.zsh;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.getty.autologinUser = "kevin";

  environment.systemPackages = with pkgs; [
    claude-code
    git
    ripgrep
    fd
    neovim
    nodejs
    python3
  ];

  environment.sessionVariables.WORKSPACE = "/workspace";

  programs.zsh.enable = true;
}
