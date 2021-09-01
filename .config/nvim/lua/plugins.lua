local function load(use)
  use {"wbthomason/packer.nvim", opt = true}

  use {
    "kraftwerk28/gtranslate.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  -- Themes
  use {"ayu-theme/ayu-vim"}
  use {"romgrk/doom-one.vim", disable = true}
  use {"joshdick/onedark.vim"}
  use {"morhetz/gruvbox"}
  use {"npxbr/gruvbox.nvim", disable = true, requires = {"rktjmp/lush.nvim"}}
  use {"RRethy/nvim-base16"}
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
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function() require("cfg.telescope") end,
  }

  use {"wellle/targets.vim"} -- More useful text objects (e.g. function arguments)

  use {"tpope/vim-fugitive"} -- Git helper

  use {
    "airblade/vim-gitgutter",
    config = function()
      local u = require("utils").u
      local gutter = u"2595"
      vim.g.gitgutter_sign_added = gutter
      vim.g.gitgutter_sign_modified = gutter
      vim.g.gitgutter_sign_removed = gutter
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
    "nvim-treesitter/nvim-treesitter",
    requires = {"nvim-treesitter/playground"},
    run = function() vim.cmd("TSUpdate") end,
    config = function() require('cfg.tree_sitter') end,
  }

  use {
    "neovim/nvim-lspconfig",
    -- "~/projects/neovim/nvim-lspconfig",
    config = function() require("cfg.lspconfig") end,
  }

  use {
    "RRethy/vim-illuminate",
    config = function()
      local utils = require("utils")
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
        vim.g.UltiSnipsExpandTrigger = '<F10>'
        vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
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
    config = function() require("cfg.completion") end,
  }

  use {
    "hrsh7th/nvim-compe",
    disable = true,
    requires = {
      "SirVer/ultisnips",
      "honza/vim-snippets",
    },
    config = function() require("cfg.completion") end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local utils = require("utils")
      local u = utils.u
      utils.highlight {"NvimTreeFolderName", "Title"}
      utils.highlight {"NvimTreeFolderIcon", "Title"}
      local opts = {
        auto_close = 1,
        indent_markers = 0,
        quit_on_open = 1,
        disable_netrw = 0,
        hijack_netrw = 1,
        highlight_opened_files = 1,
        auto_resize = 0,
        icons = {
          folder = {
            default = u"f07b",
            open = u"f07c",
            symlink = u"f0c1",
          },
        },
      }
      for k, v in pairs(opts) do
        vim.g["nvim_tree_"..k] = v
      end
    end,
  }

  use {
    "sbdchd/neoformat",
    config = function() require("cfg.neoformat") end,
  }

  use {"equalsraf/neovim-gui-shim", opt = true}

end

return function()
  local sprintf = require("utils").sprintf
  local packer_install_path =
    vim.fn.stdpath("data") ..
    "/site/pack/packer/opt/packer.nvim"
  local not_installed = vim.fn.empty(vim.fn.glob(packer_install_path)) > 0

  if not_installed then
    print("`packer.nvim` is not installed, installing...")
    local repo = "https://github.com/wbthomason/packer.nvim"
    vim.cmd(sprintf("!git clone %s %s", repo, packer_install_path))
  end

  vim.cmd("packadd packer.nvim")
  require("packer").startup {load, config = {git = {clone_timeout = 240}}}
  vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

  if not_installed then
    vim.cmd("PackerSync")
  end
end
