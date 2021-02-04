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
    'glepnir/galaxyline.nvim',
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
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local u = require'utils'.u
      local cfg = {
        sorting_strategy = 'ascending',
        prompt_prefix = u 'f002',
        prompt_position = 'top',
        color_devicons = true,
        scroll_strategy = 'cycle',
        mappings = {
          i = {
            ['<C-K>'] = actions.move_selection_previous,
            ['<C-J>'] = actions.move_selection_next,
            ['<Esc>'] = actions.close,
          },
        },
      }
      telescope.setup {defaults = cfg}
    end,
  }

  use 'wellle/targets.vim' -- More useful text objects (e.g. function arguments)
  use 'tpope/vim-fugitive' -- Git helper
  use 'airblade/vim-gitgutter'
  use 'lyokha/vim-xkbswitch'
  use 'diepm/vim-rest-console'
  use 'chrisbra/Colorizer'
  use 'mattn/emmet-vim'

  use 'neovimhaskell/haskell-vim'
  use 'pangloss/vim-javascript'
  use {'evanleck/vim-svelte', branch = 'main'}
  use 'editorconfig/editorconfig-vim'
  use 'elixir-editors/vim-elixir'
  use 'chr4/nginx.vim'

  -- use {'neoclide/coc.nvim', 'branch' = 'release'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end,
  }
  use 'nvim-treesitter/playground'

  use 'neovim/nvim-lspconfig'

  use {
    'hrsh7th/nvim-compe',
    requires = {'SirVer/ultisnips', 'honza/vim-snippets'},
    config = function()
      require'compe'.setup {
        throttle_time = 80,
        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          ultisnips = true,
        },
      }
      vim.g.UltiSnipsExpandTrigger = '<Nop>'
      vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
    end,
  }

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
