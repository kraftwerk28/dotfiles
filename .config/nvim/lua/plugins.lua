local function load(use)
  use {"wbthomason/packer.nvim", opt = true}

  use {
    "~/projects/neovim/gtranslate.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  -- Themes
  use {"ayu-theme/ayu-vim", opt = true, disable = true}
  use {"romgrk/doom-one.vim", disable = true}
  use {"joshdick/onedark.vim", disable = true}
  use {"morhetz/gruvbox", disable = true}
  use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use {"RRethy/nvim-base16"}

  use {"kyazdani42/nvim-web-devicons"}

  -- Tools
  use {
    "tpope/vim-surround",
    config = function()
      local char2nr = vim.fn.char2nr
      vim.g["surround_" .. char2nr('r')] = "{'\r'}"
      vim.g["surround_" .. char2nr('j')] = "{/* \r */}"
      vim.g["surround_" .. char2nr('c')] = "/* \r */"
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
      "kyazdani42/nvim-web-devicons", "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- local pickers = require('telescope.pickers')
      -- local finders = require('telescope.finders')
      -- local sorters = require('telescope.sorters')
      -- _G.base16 = function(opts)
      --   local results = {}
      --   for i = 1, 50 do
      --     table.insert(results, 'Result #' .. i)
      --   end
      --   pickers:new(opts, {
      --     prompt_title = "base16 themes",
      --     finder = finders.new_table {
      --       results = results,
      --     },
      --     sorter = sorters.fuzzy_with_index_bias(),
      --   }):find()
      -- end

      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local u = require("utils").u

      telescope.setup {
        defaults = {
          sorting_strategy = "ascending",
          prompt_prefix = u"f002" .. " ",
          layout_strategy = "horizontal",
          layout_config = {prompt_position = "top"},
          selection_caret = u"f054" .. ' ',
          color_devicons = true,
          scroll_strategy = "cycle",
          mappings = {
            i = {
              ["<C-K>"] = actions.move_selection_previous,
              ["<C-J>"] = actions.move_selection_next,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {previewer = false, theme = "dropdown"},
        },
      }
    end,
  }

  use {'wellle/targets.vim'} -- More useful text objects (e.g. function arguments)

  use {'tpope/vim-fugitive'} -- Git helper
  -- use {
  --   'TimUntersberger/neogit',
  --   requires = 'nvim-lua/plenary.nvim',
  --   config = function() require('neogit').setup {} end,
  -- }

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

  -- if
  --   vim.fn.executable('xkb-switch') > 0
  --   or vim.fn.executable('g3kb-switch') > 0
  -- then
  --   use {
  --     "lyokha/vim-xkbswitch",
  --     config = function()
  --       vim.g.XkbSwitchEnabled = 1
  --       if vim.env["XDG_CURRENT_DESKTOP"] == "GNOME" then
  --         vim.g.XkbSwitchLib = "/usr/local/lib/libg3kbswitch.so"
  --       end
  --     end,
  --   }
  -- end

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
    'neovim/nvim-lspconfig',
    -- '~/projects/neovim/nvim-lspconfig',
    config = function() require('cfg.lspconfig') end,
  }
  -- use {'ray-x/lsp_signature.nvim'}

  use {
    'RRethy/vim-illuminate',
    config = function()
      local utils = require('utils')
      utils.highlight {"illuminatedWord", guibg = "#303030"}
    end,
  }

  do
    vim.fn.system([[python -c "import pynvim"]])
    local disable = vim.v.shell_error ~= 0
    if disable then print("Please install python's pynvim package") end
    use {
      'SirVer/ultisnips',
      disable = disable,
      config = function()
        vim.g.UltiSnipsExpandTrigger = '<F10>'
        vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
      end,
    }
  end

  use {
    "hrsh7th/nvim-compe",
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
          -- ultisnips = true,
        },
        documentation = {border = vim.g.floatwin_border},
      }
    end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local utils = require("utils")
      local u = utils.u
      utils.highlight {"NvimTreeFolderName", "Title"}
      utils.highlight {"NvimTreeFolderIcon", "Title"}
      for k, v in pairs {
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
      } do vim.g["nvim_tree_"..k] = v end
    end,
  }

  use {
    'sbdchd/neoformat',
    config = function() require("cfg.neoformat") end,
  }

  use {"equalsraf/neovim-gui-shim", opt = true}
end

return function()
  local sprintf = require('utils').sprintf
  local packer_install_path =
    vim.fn.stdpath('data') ..
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
