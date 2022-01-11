local function load(use)
  use {"wbthomason/packer.nvim", opt = true}

  use {
    "~/projects/neovim/gtranslate.nvim",
    -- "kraftwerk28/gtranslate.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  -- Themes
  -- use {"navarasu/onedark.nvim"}
  -- use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  -- use {"~/projects/neovim/nvim-base16"}
  use {"RRethy/nvim-base16"}
  -- use {"projekt0n/github-nvim-theme"}
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
        {prefer_single_line_comments = true}
      )
    end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    -- "~/projects/neovim/telescope.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function() require("plugins.telescope") end,
  }

  use {"tpope/vim-fugitive"}
  use {
    "lewis6991/gitsigns.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require("gitsigns").setup {
        keymaps = {
        },
      }
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

  -- Missing languages in tree-sitter
  use {"neovimhaskell/haskell-vim"}
  use {"editorconfig/editorconfig-vim"}
  use {"elixir-editors/vim-elixir"}
  use {"chr4/nginx.vim"}
  use {"tpope/vim-markdown"}
  use {"adimit/prolog.vim"}
  use {"digitaltoad/vim-pug"}

  use {
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    run = function() vim.cmd("TSUpdate") end,
    config = function() require("plugins.tree_sitter") end,
  }

  use {
    "neovim/nvim-lspconfig",
    -- "~/projects/neovim/nvim-lspconfig",
    config = function() require("plugins.lspconfig") end,
  }

  use {
    "RRethy/vim-illuminate",
    disable = true,
    config = function()
      local utils = require("config.utils")
      utils.highlight {"illuminatedWord", guibg = "#303030"}
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      -- "L3MON4D3/LuaSnip",
      -- "saadparwaiz1/cmp_luasnip",
      "dcampos/nvim-snippy",
      "honza/vim-snippets",
      "dcampos/cmp-snippy",
      "hrsh7th/cmp-calc",
    },
    config = function() require("plugins.cmp") end,
  }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function()
      local utils = require("config.utils")
      local highlight = utils.highlight
      highlight {"NvimTreeFolderName", "Title"}
      highlight {"NvimTreeFolderIcon", "Title"}
      vim.g.nvim_tree_quit_on_open = 1
      vim.g.nvim_tree_indent_markers = 0
      vim.g.nvim_tree_icons = {
        folder = {
          arrow_open   = "",
          arrow_closed = "",
          default      = "",
          open         = "",
          empty        = "",
          empty_open   = "",
          symlink      = "",
          symlink_open = "",
        },
        git = {
          unstaged  = "✗",
          staged    = "✓",
          unmerged  = "",
          renamed   = "➜",
          untracked = "",
          deleted   = "",
          ignored   = "",
        },
      }
      require("nvim-tree").setup {
        auto_close             = true,
        disable_netrw          = false,
        hijack_netrw           = true,
        highlight_opened_files = true,
        auto_resize            = false,
        hijack_cursor          = true,
        git = {
          ignore = false,
        },
      }
    end,
  }
  use {"equalsraf/neovim-gui-shim", opt = true}
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
      vim.api.nvim_set_keymap("v", "<Leader>ea", "<Plug>(EasyAlign)", {})
    end,
  }
  use {"mfussenegger/nvim-dap"}

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function() require("plugins.null_ls") end,
  }

  use {
    "nvim-neorg/neorg",
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
end

local function bootstrap()
  local fn = vim.fn
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
  vim.cmd[[
    autocmd BufWritePost */plugins/init.lua source <afile> | PackerCompile
  ]]

  if not_installed then
    vim.cmd("PackerSync")
  end
end

return bootstrap
