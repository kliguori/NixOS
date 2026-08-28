{ ... }:
{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree filesystem toggle left<CR>";
      options.desc = "Explorer: Neo-tree toggle";
    }
    {
      mode = "n";
      key = "<leader>er";
      action = "<cmd>Neotree filesystem reveal left<CR>";
      options.desc = "Explorer: Reveal file in tree";
    }
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLinePick<CR>";
      options.desc = "Pick buffer";
    }
    {
      mode = "n";
      key = "<leader>bc";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<CR>";
      options.desc = "Close others";
    }
    {
      mode = "n";
      key = "<leader>b>";
      action = "<cmd>BufferLineMoveNext<CR>";
      options.desc = "Move buffer right";
    }
    {
      mode = "n";
      key = "<leader>b<";
      action = "<cmd>BufferLineMovePrev<CR>";
      options.desc = "Move buffer left";
    }
    {
      mode = "n";
      key = "<A-j>";
      action = ":m .+1<CR>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = ":m .-2<CR>==";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>Neogit<CR>";
      options.desc = "Git: Neogit";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<CR>";
      options.desc = "Git: Diffview open";
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<CR>";
      options.desc = "Git: Diffview close";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Telescope find_files cwd=~/tank/org<CR>";
      options.desc = "Org: Open file";
    }
  ];
}
