local function load()
  -- Themes
  use {'ayu-theme/ayu-vim'}
  use {'joshdick/onedark.vim'}

  -- Tools
  use {'itchyny/lightline.vim'}
  use {'junegunn/vim-emoji'}
  use {'tpope/vim-surround'}
  use {'jiangmiao/auto-pairs'}

  use {'tpope/vim-commentary'}
  use {'nvim-lua/popup.nvim'}
  use {'nvim-lua/plenary.nvim'}
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- More useful text objects (e.g. function arguments)
  use {'wellle/targets.vim'}
  use {'SirVer/ultisnips'}
  use {'honza/vim-snippets'}
  -- Git helper
  use {'tpope/vim-fugitive'}
  use {'airblade/vim-gitgutter'}
  use {'lyokha/vim-xkbswitch'}
  use {'diepm/vim-rest-console'}
  use {'chrisbra/Colorizer'}

  use {'neovimhaskell/haskell-vim'}
  use {'pangloss/vim-javascript'}
  use {'evanleck/vim-svelte', branch = 'main'}
  use {'cespare/vim-toml'}
  use {'editorconfig/editorconfig-vim'}

  -- use {'neoclide/coc.nvim', 'branch' = 'release'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end
  }
  use {'neovim/nvim-lspconfig'}
  use {'nvim-lua/completion-nvim'}
  -- Source for completion-nvim
  use {'steelsojka/completion-buffers'}
  use {'kyazdani42/nvim-web-devicons'}
  use {'kyazdani42/nvim-tree.lua'}
  -- use 'leafgarland/typescript-vim'
  -- let g:polyglot_disabled = ['typescript']
  -- use 'sheerun/vim-polyglot'
end

return function()
  vim.cmd 'packadd packer.nvim'
  local packer = require 'packer'
  packer.init {git = {clone_timeout = 240}}
  packer.startup(load)
end
