local function load(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "~/projects/neovim/gtranslate.nvim",
    -- "kraftwerk28/gtranslate.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Themes
  use({ "navarasu/onedark.nvim", disable = false })
  use({ "ellisonleao/gruvbox.nvim", disable = false })
  use({ "RRethy/nvim-base16", disable = false })
  use({ "projekt0n/github-nvim-theme" })
  use({ "rebelot/kanagawa.nvim", disable = false })
  use({ "Shatur/neovim-ayu", disable = false })

  use({ "kyazdani42/nvim-web-devicons" })

  use({
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
  })

  use({
    "numToStr/Comment.nvim",
    config = function()
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
  })

  use({
    "nvim-telescope/telescope.nvim",
    -- "~/projects/neovim/telescope.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = function()
      require("kraftwerk28.plugins.telescope")
    end,
  })

  use({
    "stevearc/dressing.nvim",
    disable = true,
    config = function()
      require("dressing").setup({
        input = {
          border = vim.g.borderchars,
        },
      })
    end,
  })

  use({
    "tpope/vim-fugitive",
    requires = {
      "tpope/vim-rhubarb",
      "tommcdo/vim-fubitive",
    },
    config = function()
      require("kraftwerk28.plugins.fugitive")
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "!*" })
    end,
  })
  use("mattn/emmet-vim")

  -- Missing / not ready to use languages in tree-sitter
  use({ "neovimhaskell/haskell-vim", disable = true })
  use({ "elixir-editors/vim-elixir", disable = true })
  -- use {"tpope/vim-markdown"}
  use("adimit/prolog.vim")
  use({ "digitaltoad/vim-pug", disable = true })
  use("bfrg/vim-jq")
  use("lifepillar/pgsql.vim")
  use({ "GEverding/vim-hocon", disable = true })

  use({
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    -- commit = "668de0951a36ef17016074f1120b6aacbe6c4515",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
    },
    run = function()
      vim.cmd("TSUpdate")
    end,
    config = function()
      require("kraftwerk28.plugins.treesitter")
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    requires = {
      "b0o/schemastore.nvim",
    },
    -- "~/projects/neovim/nvim-lspconfig",
  })

  use({
    "RRethy/vim-illuminate",
    disable = true,
    config = function()
      local utils = require("kraftwerk28.config.utils")
      utils.highlight({ "illuminatedWord", guibg = "#303030" })
    end,
  })

  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("kraftwerk28.plugins.luasnip")
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-calc",
      "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("kraftwerk28.plugins.cmp")
    end,
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("kraftwerk28.plugins.nvim-tree")
    end,
  })

  use({ "equalsraf/neovim-gui-shim", opt = true })

  use({
    "ray-x/lsp_signature.nvim",
    disable = true,
    config = function()
      require("lsp_signature").setup({
        floating_window = true,
        floating_window_above_cur_line = false,
        hint_enable = false,
      })
    end,
  })

  use({
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set({ "v", "n" }, "<Leader>ea", "<Plug>(EasyAlign)")
    end,
  })

  use({
    "mfussenegger/nvim-dap",
    config = function()
      require("kraftwerk28.plugins.dap")
    end,
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("kraftwerk28.plugins.null-ls")
    end,
  })

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install && curl -fsS -o ~/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim/app/_static/mermaid.min.js https://cdnjs.cloudflare.com/ajax/libs/mermaid/9.3.0/mermaid.min.js",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.api.nvim_exec(
        [[
          function! MkdpOpenInNewWindow(url) abort
            execute printf('silent! !firefox -P markdown-preview --new-window=%s &', a:url)
          endfunction
        ]],
        false
      )
      vim.g.mkdp_browserfunc = "MkdpOpenInNewWindow"
    end,
  })

  use({
    "Shatur/neovim-session-manager",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local c = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = c.AutoloadMode.Disabled,
      })
    end,
  })

  use({
    "p00f/clangd_extensions.nvim",
    disable = true,
    config = function()
      require("clangd_extensions").setup()
    end,
  })

  use({
    -- "github/copilot.vim",
    "~/projects/neovim/copilot.vim",
    disable = true,
  })

  use({
    "johmsalas/text-case.nvim",
    disable = true,
    config = function()
      require("kraftwerk28.plugins.textcase")
    end,
  })

  use({
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end,
  })

  use({ "marilari88/twoslash-queries.nvim" })

  use({
    "folke/which-key.nvim",
    disable = true,
    config = function()
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    requires = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    },
    config = function()
      require("kraftwerk28.plugins.lualine")
    end,
  })

  -- use({
  --   "mhartington/formatter.nvim",
  --   config = function()
  --     require("kraftwerk28.plugins.neoformat")
  --   end,
  -- })
end

-- Bootstrap
local packer_install_path = vim.fn.stdpath("data")
  .. "/site/pack/packer/opt/packer.nvim"
local not_installed = vim.fn.empty(vim.fn.glob(packer_install_path)) == 1

if not_installed then
  print("`packer.nvim` is not installed, installing...")
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/wbthomason/packer.nvim",
    packer_install_path,
  })
end

vim.cmd("packadd packer.nvim")
local packer = require("packer")

packer.startup({
  load,
  config = {
    git = { clone_timeout = 240 },
    autoremove = true,
  },
})

local augroup = vim.api.nvim_create_augroup("packer", {})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/plugins/init.lua",
  callback = function(arg)
    vim.cmd("source " .. arg.file)
    packer.compile()
  end,
  group = augroup,
})

if not_installed then
  packer.sync()
end
