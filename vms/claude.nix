{ pkgs, ... }:
let
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
  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

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
    texliveFull
    pythonEnv
    git
    neovim
    ripgrep
    fd
  ];

  environment.sessionVariables.WORKSPACE = "/workspace";

  programs.zsh.enable = true;
}
