local function load(use)
  use {'wbthomason/packer.nvim', opt = true}

  use {'kraftwerk28/gtranslate.nvim', rocks = {'lua-cjson', 'http'}}

  -- Themes
  use 'romgrk/doom-one.vim'
  use {
    'ayu-theme/ayu-vim',
    config = function()
      vim.g.ayucolor = 'mirage'
      vim.api.nvim_exec([[
        augroup alter_ayu
          autocmd!
          autocmd ColorScheme * highlight! link VertSplit Comment
        augroup END
      ]], false)
      vim.cmd 'colorscheme ayu'
    end,
  }
  -- use {
  --   'joshdick/onedark.vim',
  --   config = function() vim.g.onedark_terminal_italics = 1 end,
  -- }
  -- use {
  --   'morhetz/gruvbox',
  --   config = function()
  --     vim.g.gruvbox_italic = 1
  --     vim.g.gruvbox_contrast_dark = 'medium'
  --     vim.g.gruvbox_invert_selection = 0
  --     vim.cmd 'colorscheme gruvbox'
  --   end,
  -- }

  -- Statusline
  -- TODO: if put `disable = true` here, `requires` doesn't work
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require 'cfg.galaxyline' end,
    requires = {'kyazdani42/nvim-web-devicons'},
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
  use {
    'airblade/vim-gitgutter',
    config = function()
      local u = require'utils'.u
      local gutter = u '2595'
      vim.g.gitgutter_sign_added = gutter
      vim.g.gitgutter_sign_modified = gutter
      vim.g.gitgutter_sign_removed = gutter
    end,
  }
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
  use 'tpope/vim-markdown'

  -- use {'neoclide/coc.nvim', 'branch' = 'release'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end,
    config = function() require 'cfg.treesitter' end,
  }
  use {
    'nvim-treesitter/playground',
    requires = {'nvim-treesitter/nvim-treesitter'},
  }

  use {'neovim/nvim-lspconfig', config = function() require 'cfg.lspconfig' end}

  use {
    'hrsh7th/nvim-compe',
    requires = {'SirVer/ultisnips', 'honza/vim-snippets'},
    config = function()
      require'compe'.setup {
        throttle_time = 200,
        preselect = 'disable',
        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          ultisnips = true,
        },
      }
      vim.g.UltiSnipsExpandTrigger = '\\<Nop>'
      vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local u = require'utils'.u
      vim.cmd 'highlight link NvimTreeFolderName Title'
      vim.cmd 'highlight link NvimTreeFolderIcon Tag'
      vim.g.nvim_tree_icons = {
        folder = {default = u 'f07b', open = u 'f07c', symlink = u 'f0c1'},
      }
      vim.g.nvim_tree_auto_close = 1
      vim.g.nvim_tree_quit_on_open = 1
      vim.g.nvim_tree_indent_markers = 1
    end,
  }

  use 'glacambre/firenvim'
end

local config = {git = {clone_timeout = 240}}

return function()
  vim.api.nvim_exec([[
    packadd packer.nvim
    augroup packer_compile
      autocmd!
      autocmd BufWritePost plugins.lua PackerCompile
    augroup END
  ]], false)
  local packer = require 'packer'
  packer.startup {load, config = config}
end
