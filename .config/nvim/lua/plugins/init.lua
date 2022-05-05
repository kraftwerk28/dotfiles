local function load(use)
  use { "wbthomason/packer.nvim", opt = true }

  use {
    "~/projects/neovim/gtranslate.nvim",
    -- "kraftwerk28/gtranslate.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  -- use {
  --   disable = true,
  --   "~/projects/neovim/wpm.nvim",
  --   config = function()
  --     require("wpm").setup()
  --   end,
  -- }

  -- Themes
  -- use {"navarasu/onedark.nvim"}
  -- use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use {
    -- "~/projects/neovim/nvim-base16",
    "RRethy/nvim-base16",
    disable = true,
  }
  use { "projekt0n/github-nvim-theme", disable = true }
  use {"rebelot/kanagawa.nvim"}

  use {"kyazdani42/nvim-web-devicons"}

  use {
    "tpope/vim-surround",
    config = function()
      local char2nr = vim.fn.char2nr
      vim.g["surround_"..char2nr('r')] = "{'\r'}"
      vim.g["surround_"..char2nr('j')] = "{/* \r */}"
      vim.g["surround_"..char2nr('c')] = "/* \r */"
      vim.g["surround_"..char2nr('l')] = "[[\r]]"
      vim.g["surround_"..char2nr('i')] = "\1before: \1\r\2after: \2"
    end,
  }

  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language(
        "default",
        { prefer_single_line_comments = true }
      )
      vim.keymap.set("n", "<C-/>", "gcc", { silent = true })
      vim.keymap.set("i", "<C-/>", "<C-O>:normal gcc<CR>", { silent = true })
      vim.keymap.set("x", "<C-/>", "gc", { silent = true })
    end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    -- "~/projects/neovim/telescope.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      -- "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      -- "TC72/telescope-tele-tabby.nvim",
    },
    config = function() require("plugins.telescope") end,
  }

  use {"tpope/vim-fugitive"}
  use {
    "lewis6991/gitsigns.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require("gitsigns").setup({
        keymaps = {},
      })
      local m = vim.keymap.set
      m("n", "<Leader>gm", "<Cmd>Gdiffsplit!<CR>", { noremap = true })
      m("n", "<Leader>gs", "<Cmd>vert Git<CR>",    { noremap = true })
      m("n", "<Leader>mh", "<Cmd>diffget //2<CR>", { noremap = true })
      m("n", "<Leader>ml", "<Cmd>diffget //3<CR>", { noremap = true })
    end,
  }

  -- Still missing some features
  -- use {
  --   "TimUntersberger/neogit",
  --   requires = {"nvim-lua/plenary.nvim"},
  --   config = function()
  --     local neogit = require("neogit")
  --     local opts = {
  --       -- commit_popup = {kind = "vsplit"},
  --       kind = "vsplit",
  --       mappings = {
  --         status = {
  --           ["="] = "Toggle",
  --           ["X"] = "Discard",
  --           ["<tab>"] = "",
  --           ["x"] = "",
  --         },
  --       },
  --     }
  --     dump(opts)
  --     neogit.setup(opts)
  --   end,
  -- }

  use {"chrisbra/Colorizer"}
  use {"mattn/emmet-vim"}

  -- Missing / not ready to use languages in tree-sitter
  use {"neovimhaskell/haskell-vim"}
  use {"editorconfig/editorconfig-vim"}
  use {"elixir-editors/vim-elixir"}
  use {"chr4/nginx.vim"}
  -- use {"tpope/vim-markdown"}
  use {"adimit/prolog.vim"}
  use {"digitaltoad/vim-pug"}
  use {"bfrg/vim-jq"}

  use {
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    -- commit = "668de0951a36ef17016074f1120b6aacbe6c4515",
    requires = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    run = function() vim.cmd("TSUpdate") end,
    config = function() require("plugins.treesitter") end,
  }

  use {
    "neovim/nvim-lspconfig",
    -- "~/projects/neovim/nvim-lspconfig",
    config = function() require("plugins.lsp_servers") end,
  }

  use {
    "RRethy/vim-illuminate",
    disable = true,
    config = function()
      local utils = require("config.utils")
      utils.highlight { "illuminatedWord", guibg = "#303030" }
    end,
  }

  use {
    "L3MON4D3/LuaSnip",
    config = function() require("plugins.luasnip") end,
  }

  use {
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
    config = function() require("plugins.cmp") end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function() require("plugins.nvimtree") end,
  }

  use { "equalsraf/neovim-gui-shim", opt = true }

  -- use {
  --   "ray-x/lsp_signature.nvim",
  --   config = function()
  --     require("lsp_signature").setup {
  --       floating_window = true,
  --       floating_window_above_cur_line = false,
  --       hint_enable = false,
  --     }
  --   end,
  -- }

  use {
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set("v", "<Leader>ea", "<Plug>(EasyAlign)")
    end,
  }
  use { "mfussenegger/nvim-dap" }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function() require("plugins.null_ls") end,
  }

  use {
    "nvim-neorg/neorg",
    disable = true,
    requires = {"nvim-lua/plenary.nvim"},
    after = {"nvim-treesitter"},
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                my_workspace = "~/notes"
              },
            },
          }
        },
      }
    end,
  }

  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = {"markdown"},
    config = function()
      vim.g.mkdp_filetypes = {"markdown"}
    end,
  }

  use { "~/projects/neovim/copilot.vim", disable = true }
end

local function bootstrap()
  local fn, api = vim.fn, vim.api
  local packer_install_path =
    fn.stdpath("data").."/site/pack/packer/opt/packer.nvim"
  local not_installed = fn.empty(fn.glob(packer_install_path)) == 1

  if not_installed then
    print("`packer.nvim` is not installed, installing...")
    local repo = "https://github.com/wbthomason/packer.nvim"
    vim.cmd(("!git clone %s %s"):format(repo, packer_install_path))
  end

  vim.cmd("packadd packer.nvim")
  require("packer").startup {
    load,
    config = {
      git = {clone_timeout = 240},
    },
  }
  api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/plugins/init.lua",
    command = "source <afile> | PackerCompile",
  })
  if not_installed then
    vim.cmd("PackerSync")
  end
end

return bootstrap
