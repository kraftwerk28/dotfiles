return {
  { import = "kraftwerk28.plugins.specs" },

  -- {
  --   dir = "~/projects/neovim/gtranslate.nvim",
  --   -- "kraftwerk28/gtranslate.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  -- },

  { "mattn/emmet-vim", enabled = false },

  { "adimit/prolog.vim" },

  { "lifepillar/pgsql.vim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
      "marilari88/twoslash-queries.nvim",
    },
  },

  {
    "equalsraf/neovim-gui-shim",
    opt = true,
  },

  {
    "rmagatti/auto-session",
    opts = {
      suppressed_dirs = { "~/" },
      close_filetypes_on_save = { "checkhealth", "oil", "NvimTree" },
    },
    init = function()
      vim.go.sessionoptions =
        "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    enabled = false,
    config = true,
  },

  {
    "folke/twilight.nvim",
    opts = {},
  },

  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },
}
