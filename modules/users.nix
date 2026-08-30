{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "users/root/password".neededForUsers = true;
    "users/kevin/password".neededForUsers = true;
  };

  users = {
    mutableUsers = lib.mkForce false;
    users = {
      root.hashedPasswordFile = config.sops.secrets."users/root/password".path;
      kevin = {
        isNormalUser = true;
        home = "/home/kevin";
        uid = 1000;
        createHome = true;
        shell = pkgs.zsh;
        description = "Kevin Liguori";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPasswordFile = config.sops.secrets."users/kevin/password".path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjOZvkhZPv1wkLTfC+3A1PqVcAEa6svStem0QCT7PoQ kevin@sherlock"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMScW1nyuyek2PI7Jyaa6Ec5jfMafsR+RpuYuR3rVlV kevin@gregson"
        ];
      };
    };
  };

  environment.persistence.${config.systemOptions.impermanence.persistRoot}.users.kevin = {
    directories = config.systemOptions.impermanence.persistUserDirs;
    files = config.systemOptions.impermanence.persistUserFiles;
  };

  home-manager.users.kevin.imports = [
    inputs.nixvim.homeModules.nixvim
    ../home
  ];
}
