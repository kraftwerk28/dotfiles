local function load()
  use {'wbthomason/packer.nvim', opt = true}

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
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      print('Loading bufferline')
      require'bufferline'.setup()
    end
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
  use {'editorconfig/editorconfig-vim'}

  -- use {'neoclide/coc.nvim', 'branch' = 'release'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end
  }
  use {'neovim/nvim-lspconfig'}
  use {'nvim-lua/completion-nvim'}
  use {'steelsojka/completion-buffers'}
  use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'}}
end

return function()
  vim.cmd 'packadd packer.nvim'
  local packer = require 'packer'
  packer.init()
  packer.startup(load)
end
