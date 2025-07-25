local themes = {
  {
    "marko-cerovac/material.nvim",
    enabled = false,
    lazy = false,
    config = function() end,
  },
  {
    "navarasu/onedark.nvim",
    enabled = false,
    lazy = false,
    config = function()
      require "onedark".setup {
        style = "dark", -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      }
      require "onedark".load()
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    lazy = false,
    config = function()
      require("gruvbox").setup({
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
      })
      vim.cmd.colorscheme "gruvbox"
    end,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    enabled = false,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "original"
      -- vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme "gruvbox-material"
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    enabled = false,
    lazy = false,
    config = function()
      local groups = {
        all = {
          TabLineSel = { link = "TabLine" },
        },
      }
      require("github-theme").setup({
        -- options = {
        --   hide_nc_statusline = false,
        -- },
        groups = groups,
      })
      vim.cmd.colorscheme("github_dark_default")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = false,
    config = function()
      require("kanagawa").setup {
        background = {
          dark = "wave",
          light = "lotus",
        },
      }
      vim.cmd.colorscheme "kanagawa"
    end,
  },
}

local plugins = {
  -- {
  --   dir = "~/projects/neovim/gtranslate.nvim",
  --   -- "kraftwerk28/gtranslate.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  -- },

  { "kyazdani42/nvim-web-devicons" },
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
      require("ts_context_commentstring").setup({
        languages = {
          c = {
            __default = "// %s",
            __multiline = "/* %s */",
          },
        },
      })
      require("Comment").setup({
        pre_hook = require(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
      })
      local mopt = { silent = true, remap = true }
      vim.keymap.set("n", "<C-/>", "gccj", mopt)
      vim.keymap.set("i", "<C-/>", "<Cmd>:normal gcc<CR>", mopt)
      vim.keymap.set("x", "<C-/>", "gcgv", mopt)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- "~/projects/neovim/telescope.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require "kraftwerk28.plugins.telescope"
    end,
  },
  { "nvim-telescope/telescope-symbols.nvim" },
  {
    "stevearc/dressing.nvim",
    enabled = false,
    config = function()
      require("dressing").setup({
        input = {
          border = vim.g.borderchars,
        },
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
      "tommcdo/vim-fubitive",
    },
    config = function()
      require("kraftwerk28.plugins.fugitive")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    config = function()
      require("colorizer").setup({ "!*" })
    end,
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
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    -- commit = "668de0951a36ef17016074f1120b6aacbe6c4515",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = function()
      vim.cmd("TSUpdate")
    end,
    config = function()
      require("kraftwerk28.plugins.treesitter")
    end,
  },
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
      local utils = require("kraftwerk28.config.utils")
      utils.highlight({ "illuminatedWord", guibg = "#303030" })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("kraftwerk28.plugins.luasnip")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-calc",
      "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "kraftwerk28.plugins.cmp"
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("kraftwerk28.plugins.nvim-tree")
    end,
  },
  {
    "equalsraf/neovim-gui-shim",
    opt = true,
  },
  {
    "ray-x/lsp_signature.nvim",
    enabled = false,
    config = function()
      require("lsp_signature").setup {
        floating_window = true,
        floating_window_above_cur_line = false,
        hint_enable = false,
      }
    end,
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set({ "v", "n" }, "<Leader>ea", "<Plug>(EasyAlign)")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "kraftwerk28.plugins.dap"
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require "conform"
      conform.setup {
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
      }
      vim.keymap.set("n", "<Leader>f", function()
        conform.format()
      end, { desc = "[F]ormat" })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    config = function()
      require "kraftwerk28.plugins.nvim_lint"
    end,
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
    config = function()
      require("clangd_extensions").setup()
    end,
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
    config = function()
      require("twilight").setup()
    end,
  },
  { "marilari88/twoslash-queries.nvim" },
  {
    "folke/which-key.nvim",
    enabled = false,
    config = function()
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    },
    config = function()
      require("kraftwerk28.plugins.lualine")
    end,
  },

  -- ({
  --   "mhartington/formatter.nvim",
  --   config = function()
  --     require("kraftwerk28.plugins.neoformat")
  --   end,
  -- })
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not vim.uv.fs_stat(lazypath) then
  local clone_result = vim
    .system {
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable", -- latest stable release
      lazyrepo,
      lazypath,
    }
    :wait()
  if clone_result.code ~= 0 then
    vim.notify("Failed to clone Lazy repo", vim.log.levels.ERROR)
  end
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup {
  spec = vim.iter { themes, plugins }:flatten():totable(),
  checker = { enabled = true },
}
