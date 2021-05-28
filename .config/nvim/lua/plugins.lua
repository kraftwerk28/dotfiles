local function load(use)
  use {'wbthomason/packer.nvim', opt = true}

  use {'~/projects/neovim/gtranslate.nvim', rocks = {'lua-cjson', 'http'}}

  -- Themes
  use {'ayu-theme/ayu-vim', opt = true, disable = true}
  use {'romgrk/doom-one.vim', disable = true}
  use {'joshdick/onedark.vim', disable = true}
  use {'morhetz/gruvbox', disable = true}
  use {'npxbr/gruvbox.nvim', disable = true, requires = {'rktjmp/lush.nvim'}}
  use {'RRethy/nvim-base16'}

  use {'kyazdani42/nvim-web-devicons'}

  -- Tools
  use {
    'tpope/vim-surround',
    config = function()
      local char2nr = vim.fn.char2nr
      vim.g['surround_' .. char2nr('r')] = "{'\r'}"
      vim.g['surround_' .. char2nr('j')] = "{/* \r */}"
      vim.g['surround_' .. char2nr('c')] = "/* \r */"
    end,
  }

  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language(
        'default', {prefer_single_line_comments = true}
      )
    end,
  }

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
      -- local previewers = require 'telescope.previewers'
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

  use {'wellle/targets.vim'} -- More useful text objects (e.g. function arguments)

  use {'tpope/vim-fugitive'} -- Git helper

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

  if vim.fn.executable('xkb-switch') > 0 or vim.fn.executable('g3kb-switch') > 0 then
    use {
      'lyokha/vim-xkbswitch',
      config = function()
        vim.g.XkbSwitchEnabled = 1
        if vim.env['XDG_CURRENT_DESKTOP'] == 'GNOME' then
          vim.g.XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
        end
      end,
    }
  end

  use {'chrisbra/Colorizer'}

  use {'mattn/emmet-vim'}

  -- Missing languages in tree-sitter
  use {'neovimhaskell/haskell-vim'}
  use {'editorconfig/editorconfig-vim'}
  use {'elixir-editors/vim-elixir'}
  use {'chr4/nginx.vim'}
  use {'tpope/vim-markdown'}
  use {'adimit/prolog.vim'}

  if vim.fn.has('unix') > 0 and
    (vim.fn.executable('g++') > 0 or vim.fn.executable('clang++') > 0) then
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/playground',
        -- 'nvim-treesitter/nvim-treesitter-refactor',
      },
      run = function() vim.cmd('TSUpdate') end,
      config = function() require('cfg.tree_sitter') end,
    }
  end

  use {
    'neovim/nvim-lspconfig',
    -- '~/projects/neovim/nvim-lspconfig',
    config = function() require('cfg.lspconfig') end,
  }

  use {
    'RRethy/vim-illuminate',
    disable = true,
    config = function()
      local utils = require('utils')
      utils.highlight {'illuminatedWord', bg = '#303A49'}
    end,
  }

  use {
    'SirVer/ultisnips',
    disable = true,
    config = function()
      vim.g.UltiSnipsExpandTrigger = '<F10>'
      vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
    end,
  }

  use {
    'hrsh7th/nvim-compe',
    requires = {'SirVer/ultisnips', 'honza/vim-snippets', opt = true},
    config = function()
      require('compe').setup {
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
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local u = require('utils').u
      vim.cmd 'highlight link NvimTreeFolderName Title'
      vim.cmd 'highlight link NvimTreeFolderIcon Tag'
      vim.g.nvim_tree_icons = {
        folder = {default = u 'f07b', open = u 'f07c', symlink = u 'f0c1'},
      }
      vim.g.nvim_tree_auto_close = 1
      vim.g.nvim_tree_indent_markers = 1
      vim.g.nvim_tree_quit_on_open = 1
      vim.g.nvim_tree_disable_netrw = 0
      vim.g.nvim_tree_hijack_netrw = 1
    end,
  }

  use {
    'sbdchd/neoformat',
    config = function()
      for _, ft in ipairs {
        'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
      } do
        vim.g['neoformat_enabled_' .. ft] = {}
      end
      vim.g.neoformat_try_formatprg = 1
      vim.g.neoformat_run_all_formatters = 0
    end,
  }
end

return function()
  local sprintf = require('utils').sprintf
  local packer_install_path = vim.fn.stdpath('data') ..
                                '/site/pack/packer/opt/packer.nvim'
  local not_installed = vim.fn.empty(vim.fn.glob(packer_install_path)) > 0

  if not_installed then
    print('`packer.nvim` is not installed, installing...')
    local repo = 'https://github.com/wbthomason/packer.nvim'
    vim.cmd(sprintf('!git clone %s %s', repo, packer_install_path))
  end

  vim.cmd('packadd packer.nvim')
  require('packer').startup {load, config = {git = {clone_timeout = 240}}}
  vim.cmd('autocmd BufWritePost plugins.lua :PackerCompile')

  if not_installed then
    vim.cmd('PackerSync')
  end
end
