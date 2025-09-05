return {
  { import = "kraftwerk28.plugins.specs" },

  -- {
  --   dir = "~/projects/neovim/gtranslate.nvim",
  --   -- "kraftwerk28/gtranslate.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  -- },

  {
    "tpope/vim-surround",
    config = function()
      local surr = setmetatable({}, {
        __newindex = function(_, k, v)
          vim.g["surround_" .. vim.fn.char2nr(k)] = v
        end,
      })
      surr["r"] = "{'\r'}"
      surr["j"] = "{/* \r */}"
      surr["c"] = "/* \r */"
      surr["l"] = "[[\r]]"
      surr["i"] = "\1before: \1\r\2after: \2"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  { "mattn/emmet-vim", enabled = false },

  { "adimit/prolog.vim" },

  { "lifepillar/pgsql.vim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
  },

  {
    "equalsraf/neovim-gui-shim",
    opt = true,
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "<Leader>ea", "<Plug>(EasyAlign)", mode = { "v", "n" } },
    },
    cmd = { "EasyAlign" },
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = false,
    config = function()
      local c = require "session_manager.config"
      return {
        autoload_mode = c.AutoloadMode.Disabled,
      }
    end,
  },

  {
    "rmagatti/auto-session",
    opts = {
      suppressed_dirs = { "~/" },
      close_filetypes_on_save = { "checkhealth", "oil", "NvimTree" },
    },
    init = function()
      vim.go.sessionoptions =
        "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    enabled = false,
    config = true,
  },
  {
    "johmsalas/text-case.nvim",
    enabled = false,
    config = function()
      require("kraftwerk28.plugins.textcase")
    end,
  },
  {
    "folke/twilight.nvim",
    config = true,
  },
  { "marilari88/twoslash-queries.nvim" },

  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },
}
