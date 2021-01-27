local function load(use)
  local use_rocks = require'packer'.use_rocks

  use_rocks {'lua-cjson', 'http'}

  use {'wbthomason/packer.nvim', opt = true}

  -- Themes
  use 'ayu-theme/ayu-vim'
  -- use 'joshdick/onedark.vim'
  -- use 'morhetz/gruvbox'

  -- Statusline
  use {
    '~/projects/neovim/galaxyline.nvim',
    branch = 'main',
    config = function() require 'cfg.galaxyline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  -- Tools
  use 'junegunn/vim-emoji'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'

  use 'tpope/vim-commentary'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons', 'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
  }

  use 'wellle/targets.vim' -- More useful text objects (e.g. function arguments)
  use 'Shougo/neosnippet.vim'
  use 'Shougo/neosnippet-snippets'

  -- Git helper
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'lyokha/vim-xkbswitch'
  use 'diepm/vim-rest-console'
  use 'chrisbra/Colorizer'

  use 'neovimhaskell/haskell-vim'
  use 'pangloss/vim-javascript'
  use {'evanleck/vim-svelte', branch = 'main'}
  use 'editorconfig/editorconfig-vim'

  -- use {'neoclide/coc.nvim', 'branch' = 'release'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end,
  }
  use 'nvim-treesitter/playground'

  use 'neovim/nvim-lspconfig'
  use {'nvim-lua/completion-nvim'}
  use 'steelsojka/completion-buffers'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
end

local config = {git = {clone_timeout = 240}}

return function()
  vim.cmd 'packadd packer.nvim'
  local packer = require 'packer'
  packer.startup {load, config = config}
  vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'
end
