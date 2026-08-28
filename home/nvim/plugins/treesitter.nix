{ config, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
      nix
      python
      rust
      c
      lua
      typst
      bash
      json
      yaml
      markdown
      markdown_inline
      toml
      kdl
    ];
  };
}
