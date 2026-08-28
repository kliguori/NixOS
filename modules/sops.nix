{ hostName, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age = {
      keyFile = "/persist/sops/${hostName}-age.key";
      sshKeyPaths = [ ];
      generateKey = false;
    };
  };
}
