{ hostName, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      extended = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -lah";
      cl = "clear";
      ".." = "cd ..";
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";
      gf = "git fetch";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      vi = "nvim";
      nrs = "sudo nixos-rebuild switch --flake ~/tank/nixos#${hostName}";
      nd = "nix develop --profile .gcroot";
      cvm = "nix run ~/tank/nixos#nixosConfigurations.claude.config.microvm.declaredRunner";
    };
  };
}
