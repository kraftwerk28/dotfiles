local function load(use)
  use {"wbthomason/packer.nvim", opt = true}

  use {
    "kraftwerk28/gtranslate.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  -- Themes
  use {"navarasu/onedark.nvim"}
  use {
    "npxbr/gruvbox.nvim",
    requires = {"rktjmp/lush.nvim"},
  }
  use {
    -- "~/projects/neovim/nvim-base16"
    "RRethy/nvim-base16"
  }
  use {"projekt0n/github-nvim-theme"}

  use {"kyazdani42/nvim-web-devicons"}

  -- Tools
  use {
    "tpope/vim-surround",
    config = function()
      local char2nr = vim.fn.char2nr
      vim.g["surround_"..char2nr('r')] = "{'\r'}"
      vim.g["surround_"..char2nr('j')] = "{/* \r */}"
      vim.g["surround_"..char2nr('c')] = "/* \r */"
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

  use {"wellle/targets.vim"} -- More useful text objects (e.g. function arguments)

  use {"tpope/vim-fugitive"} -- Git helper

  use {
    "airblade/vim-gitgutter",
    config = function()
      local u = require("config.utils").u
      local gutter = u"2595"
      vim.g.gitgutter_sign_added    = gutter
      vim.g.gitgutter_sign_modified = gutter
      vim.g.gitgutter_sign_removed  = gutter
    end,
  }

  use {"chrisbra/Colorizer"}
  use {"mattn/emmet-vim"}

  -- Missing languages in tree-sitter
  use {"neovimhaskell/haskell-vim"}
  use {"editorconfig/editorconfig-vim"}
  use {"elixir-editors/vim-elixir"}
  use {"chr4/nginx.vim"}
  use {"tpope/vim-markdown"}
  use {"adimit/prolog.vim"}

  use {
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    requires = {"nvim-treesitter/playground"},
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

  do
    vim.fn.system([[python -c "import pynvim"]])
    local disable = vim.v.shell_error ~= 0
    if disable then print("Please install python's pynvim package") end
    use {
      "SirVer/ultisnips",
      config = function()
        vim.g.UltiSnipsExpandTrigger       = "<F10>"
        vim.g.UltiSnipsJumpForwardTrigger  = "<C-J>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<C-K>"
      end,
    }
  end

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "SirVer/ultisnips",
      "honza/vim-snippets",
    },
    config = function() require("plugins.cmp") end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local utils = require("config.utils")
      local u, highlight = utils.u, utils.highlight
      highlight {"NvimTreeFolderName", "Title"}
      highlight {"NvimTreeFolderIcon", "Title"}
      vim.g.nvim_tree_quit_on_open = 1
      vim.g.nvim_tree_indent_markers = 0
      vim.g.nvim_tree_icons = {
        folder = {
          default = u"f07b",
          open    = u"f07c",
          symlink = u"f0c1",
        },
      }
      require("nvim-tree").setup {
        auto_close             = true,
        disable_netrw          = false,
        hijack_netrw           = true,
        highlight_opened_files = true,
        auto_resize            = false,
        hijack_cursor          = true,
      }
    end,
  }

  use {
    "sbdchd/neoformat",
    config = function() require("plugins.neoformat") end,
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
  vim.cmd("autocmd BufWritePost plugins.lua source <afile> | PackerCompile")

  if not_installed then
    vim.cmd("PackerSync")
  end
end

return bootstrap
