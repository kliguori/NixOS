{
  config,
  lib,
  pkgs,
  hostName,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware.enableAllFirmware = true;
  zramSwap.enable = true;
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking = {
    hostName = hostName;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;

  security = {
    protectKernelImage = true;
    sudo.execWheelOnly = true;
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale = {
      enable = true;
      extraUpFlags = [ "--accept-routes" ];
    };
  };

  systemOptions.impermanence = {
    persistDirs = [ "/var/lib/tailscale" ];
    persistFiles = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  environment.systemPackages = with pkgs; [
    tree
    pciutils
    unzip
    neovim
    curl
    wget
    eza
    jq
    dnsutils
    iproute2
    iputils
    nmap
    traceroute
    htop
    strace
    lsof
    ripgrep
    fd
    bat
    duf
    ncdu
    rsync
    parted
    git
    usbutils
    lm_sensors
    btop
    ncurses
  ];
}
