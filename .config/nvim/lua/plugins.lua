local function load(use)
  use {'wbthomason/packer.nvim', opt = true}

  -- Themes
  use 'ayu-theme/ayu-vim'
  use 'joshdick/onedark.vim'
  use 'morhetz/gruvbox'
  use 'shinchu/lightline-gruvbox.vim'

  -- Statusline
  use {'itchyny/lightline.vim', disable = true}
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require 'galaxyline_cfg' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  -- Tools
  use 'junegunn/vim-emoji'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'

  use 'tpope/vim-commentary'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
  }

  -- More useful text objects (e.g. function arguments)
  use 'wellle/targets.vim'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
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
  use 'nvim-lua/completion-nvim'
  use 'steelsojka/completion-buffers'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
end

return function()
  vim.cmd 'packadd packer.nvim'
  local packer = require 'packer'
  packer.startup {load, config = {git = {clone_timeout = 240}}}
  vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'
end
