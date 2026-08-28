{
  pkgs,
  inputs,
  autoImport,
  ...
}:
{
  imports = autoImport ./.;

  programs.home-manager.enable = true;

  home = {
    homeDirectory = "/home/kevin";
    stateVersion = "26.05";

    packages =
      with pkgs;
      [
        signal-desktop
        anki
        zoom-us
        slack
        google-chrome
        openai-whisper
        yt-dlp
        mpv
        lua-language-server
        nixd
        pyright
        ruff
        clang-tools
        rust-analyzer
        haskell-language-server
        ghc
        ocamlPackages.ocaml-lsp
        nixfmt
        rustc
        cargo
        rustfmt
        clippy
        texlab
        ormolu
        ocamlformat
      ]
      ++ [ inputs.hibi.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
