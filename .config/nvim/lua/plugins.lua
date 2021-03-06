local function load(use)
  use {'wbthomason/packer.nvim', opt = true}

  use {'kraftwerk28/gtranslate.nvim', rocks = {'lua-cjson', 'http'}}

  -- Themes
  use {'romgrk/doom-one.vim', disable = true}
  use {
    'ayu-theme/ayu-vim',
    setup = function()
      vim.g.ayucolor = 'mirage'
      vim.api.nvim_exec([[
        augroup alter_ayu
          autocmd!
          autocmd ColorScheme * highlight! link VertSplit Comment
        augroup END
      ]], false)
      vim.cmd 'colorscheme ayu'
      -- Loading statusline here lately because colors won't work
      require'utils'.load 'statusline'
    end,
  }

  use {
    'joshdick/onedark.vim',
    disable = true,
    config = function() vim.g.onedark_terminal_italics = 1 end,
  }

  use {
    'morhetz/gruvbox',
    disable = true,
    config = function()
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_contrast_dark = 'medium'
      vim.g.gruvbox_invert_selection = 0
      vim.cmd 'colorscheme gruvbox'
    end,
  }

  use 'kyazdani42/nvim-web-devicons'

  -- Tools
  use 'tpope/vim-surround'
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
        prompt_prefix = u 'f002' .. ' ',
        prompt_position = 'top',
        selection_caret = u 'f054' .. ' ',
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
  use 'chrisbra/Colorizer'
  use 'mattn/emmet-vim'

  -- Missing languages in tree-sitter
  use 'neovimhaskell/haskell-vim'
  use 'editorconfig/editorconfig-vim'
  use 'elixir-editors/vim-elixir'
  use 'chr4/nginx.vim'
  use 'tpope/vim-markdown'

  if vim.fn.executable('g++') or vim.fn.executable('clang++') then
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.cmd 'TSUpdate' end,
      config = function() require 'cfg.treesitter' end,
    }
    use 'nvim-treesitter/playground'
  end

  use {'neovim/nvim-lspconfig', config = function() require 'cfg.lspconfig' end}

  use {
    'hrsh7th/nvim-compe',
    requires = {'SirVer/ultisnips', 'honza/vim-snippets', opt = true},
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
      -- Doesn't work so I have to manually unmap it below
      vim.g.UltiSnipsExpandTrigger = '<Nop>'
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
      vim.g.nvim_tree_disable_netrw = 0
    end,
  }
end

local config = {git = {clone_timeout = 240}}

return function()
  local sprintf = require'utils'.sprintf
  local packer_install_path = vim.fn.stdpath('data') ..
                                '/site/pack/packer/opt/packer.nvim'
  local not_installed = vim.fn.empty(vim.fn.glob(packer_install_path)) > 0

  if not_installed then
    print 'packer is not installed, installing...'
    local repo = 'https://github.com/wbthomason/packer.nvim'
    vim.cmd(sprintf('!git clone %s %s', repo, packer_install_path))
  end

  vim.cmd 'packadd packer.nvim'
  require'packer'.startup {load, config = config}

  if not_installed then vim.cmd 'PackerSync' end
end
