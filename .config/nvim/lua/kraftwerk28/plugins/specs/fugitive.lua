return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
    "tommcdo/vim-fubitive",
  },
  keys = {
    { "<Leader>gp", "<Cmd>Git push origin HEAD<CR>", ft = "fugitive" },

    -- Open split
    { "<Leader>gs", "<Cmd>vert Git<CR>" },
    { "<Leader>gb", ":GBrowse!<CR>", mode = { "n", "v" } },

    -- Merge conflicts
    { "<Leader>gm", "<Cmd>Gdiffsplit!<CR>" },
    { "<Leader>gh", "<Cmd>diffget //2<CR>" },
    { "<Leader>gl", "<Cmd>diffget //3<CR>" },
  },
  cmd = { "G", "Git" },
}
