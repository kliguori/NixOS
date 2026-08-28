{ ... }:
{
  programs.nixvim.plugins = {
    neogit = {
      enable = true;
      settings = {
        integrations = {
          diffview = true;
          telescope = true;
        };
      };
    };

    diffview.enable = true;

    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        signcolumn = true;
      };
    };
  };
}
