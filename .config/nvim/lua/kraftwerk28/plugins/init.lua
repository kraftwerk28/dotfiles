return {
  { import = "kraftwerk28.plugins.specs" },

  -- {
  --   "marko-cerovac/material.nvim",
  --   enabled = false,
  --   lazy = false,
  --   config = function() end,
  -- },

  -- {
  --   "navarasu/onedark.nvim",
  --   enabled = false,
  --   lazy = false,
  --   config = function()
  --     require "onedark".setup {
  --       style = "dark", -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  --     }
  --     require "onedark".load()
  --   end,
  -- },

  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    opts = {
      contrast = "soft", -- can be "hard", "soft" or empty string
      italic = {
        strings = false,
      },
      overrides = {
        -- Search = { underdashed = true },
        -- CurSearch = { underdashed = true },
        StatusLine = { reverse = false },
        StatusLineNC = { reverse = false },
      },
    },
    init = function()
      vim.cmd.colorscheme "gruvbox"
    end,
  },

  -- {
  --   "sainnhe/gruvbox-material",
  --   lazy = false,
  --   enabled = false,
  --   config = function()
  --     vim.g.gruvbox_material_background = "medium"
  --     vim.g.gruvbox_material_foreground = "original"
  --     -- vim.g.gruvbox_material_enable_italic = true
  --     vim.cmd.colorscheme "gruvbox-material"
  --   end,
  -- },

  -- {
  --   "projekt0n/github-nvim-theme",
  --   enabled = false,
  --   lazy = false,
  --   config = function()
  --     local groups = {
  --       all = {
  --         TabLineSel = { link = "TabLine" },
  --       },
  --     }
  --     require("github-theme").setup({
  --       -- options = {
  --       --   hide_nc_statusline = false,
  --       -- },
  --       groups = groups,
  --     })
  --     vim.cmd.colorscheme("github_dark_default")
  --   end,
  -- },

  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   enabled = false,
  --   config = function()
  --     require("kanagawa").setup {
  --       background = {
  --         dark = "wave",
  --         light = "lotus",
  --       },
  --     }
  --     vim.cmd.colorscheme "kanagawa"
  --   end,
  -- },

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
    "numToStr/Comment.nvim",
    config = function()
      require("ts_context_commentstring").setup {
        languages = {
          c = {
            __default = "// %s",
            __multiline = "/* %s */",
          },
        },
      }
      require("Comment").setup {
        pre_hook = require(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
      }
      local mopt = { silent = true, remap = true }
      vim.keymap.set("n", "<C-/>", "gccj", mopt)
      vim.keymap.set("i", "<C-/>", "<Cmd>:normal gcc<CR>", mopt)
      vim.keymap.set("x", "<C-/>", "gcgv", mopt)
    end,
  },

  { "nvim-telescope/telescope-symbols.nvim" },

  {
    "stevearc/dressing.nvim",
    enabled = false,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    opts = { "!*" },
  },
  { "mattn/emmet-vim" },
  { "neovimhaskell/haskell-vim", enabled = false },
  { "elixir-editors/vim-elixir", enabled = false },
  -- use {"tpope/vim-markdown"}
  { "adimit/prolog.vim" },
  { "digitaltoad/vim-pug", enabled = false },
  { "bfrg/vim-jq" },
  { "lifepillar/pgsql.vim" },
  { "GEverding/vim-hocon", enabled = false },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    -- "~/projects/neovim/nvim-lspconfig",
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
    config = function()
      local utils = require("kraftwerk28.utils")
      utils.highlight({ "illuminatedWord", guibg = "#303030" })
    end,
  },
  {
    "equalsraf/neovim-gui-shim",
    opt = true,
  },
  {
    "ray-x/lsp_signature.nvim",
    enabled = false,
    opts = {
      floating_window = true,
      floating_window_above_cur_line = false,
      hint_enable = false,
    },
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set({ "v", "n" }, "<Leader>ea", "<Plug>(EasyAlign)")
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        vue = { "prettierd" },
        svelte = { "prettierd" },
        markdown = { "prettierd" },
        html = { "prettierd" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    keys = {
      {
        "<Leader>f",
        function()
          require "conform".format()
        end,
        mode = "n",
        desc = "[F]ormat",
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd [[
        function MkdpOpenFirefox(url)
          silent! execute('!firefox -P markdown-preview --new-window=' . a:url . ' &')
        endfunction
      ]]
      vim.g.mkdp_browserfunc = "MkdpOpenFirefox"

      -- TODO: find why v:lua doesn't work here
      -- _G.mkdp_open_firefox = function(url)
      --   vim.cmd(
      --     ("silent! !firefox -P markdown-preview --new-window=%s &"):format(url)
      --   )
      -- end
      -- vim.g.mkdp_browserfunc = "v:lua.mkdp_open_firefox"
    end,
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local c = require "session_manager.config"
      require("session_manager").setup {
        autoload_mode = c.AutoloadMode.Disabled,
      }
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    enabled = false,
    config = true,
  },
  {
    -- "github/copilot.vim",
    "~/projects/neovim/copilot.vim",
    enabled = false,
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
    "folke/which-key.nvim",
    enabled = false,
    config = true,
  },

  -- ({
  --   "mhartington/formatter.nvim",
  --   config = function()
  --     require("kraftwerk28.plugins.neoformat")
  --   end,
  -- })
}
