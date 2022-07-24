local function load(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "~/projects/neovim/gtranslate.nvim",
    -- "kraftwerk28/gtranslate.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- use {
  --   disable = true,
  --   "~/projects/neovim/wpm.nvim",
  --   config = function()
  --     require("wpm").setup()
  --   end,
  -- }

  -- Themes
  use({ "navarasu/onedark.nvim" })
  -- use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use({
    -- "~/projects/neovim/nvim-base16",
    "RRethy/nvim-base16",
    -- disable = true,
  })
  use({ "projekt0n/github-nvim-theme" })
  use({ "rebelot/kanagawa.nvim" })

  use({ "kyazdani42/nvim-web-devicons" })

  use({
    "tpope/vim-surround",
    config = function()
      local char2nr = vim.fn.char2nr
      vim.g["surround_" .. char2nr("r")] = "{'\r'}"
      vim.g["surround_" .. char2nr("j")] = "{/* \r */}"
      vim.g["surround_" .. char2nr("c")] = "/* \r */"
      vim.g["surround_" .. char2nr("l")] = "[[\r]]"
      vim.g["surround_" .. char2nr("i")] = "\1before: \1\r\2after: \2"
    end,
  })

  use({
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language(
        "default",
        { prefer_single_line_comments = true }
      )
      local opt = { silent = true, remap = true }
      vim.keymap.set("n", "<C-/>", "gcc", opt)
      vim.keymap.set("i", "<C-/>", "<C-O>:normal! gcc<CR>", opt)
      vim.keymap.set("x", "<C-/>", "gcgv", opt)
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    -- "~/projects/neovim/telescope.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = function()
      require("kraftwerk28.plugins.telescope")
    end,
  })

  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb", "tommcdo/vim-fubitive" },
    config = function()
      vim.keymap.set("n", "<Leader>gs", "<Cmd>vert Git<CR>")
      vim.keymap.set("n", "<Leader>gb", "<Cmd>GBrowse<CR>")

      -- Merge conflicts
      vim.keymap.set("n", "<Leader>gm", "<Cmd>Gdiffsplit!<CR>")
      vim.keymap.set("n", "<Leader>gh", "<Cmd>diffget //2<CR>")
      vim.keymap.set("n", "<Leader>gl", "<Cmd>diffget //3<CR>")
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        keymaps = {},
      })
    end,
  })

  -- Still missing some features
  -- use {
  --   "TimUntersberger/neogit",
  --   requires = {"nvim-lua/plenary.nvim"},
  --   config = function()
  --     local neogit = require("neogit")
  --     local opts = {
  --       -- commit_popup = {kind = "vsplit"},
  --       kind = "vsplit",
  --       mappings = {
  --         status = {
  --           ["="] = "Toggle",
  --           ["X"] = "Discard",
  --           ["<tab>"] = "",
  --           ["x"] = "",
  --         },
  --       },
  --     }
  --     neogit.setup(opts)
  --   end,
  -- }

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "!*" })
    end,
  })
  use("mattn/emmet-vim")

  -- Missing / not ready to use languages in tree-sitter
  use("neovimhaskell/haskell-vim")
  use("editorconfig/editorconfig-vim")
  use("elixir-editors/vim-elixir")
  use("chr4/nginx.vim")
  -- use {"tpope/vim-markdown"}
  use("adimit/prolog.vim")
  use("digitaltoad/vim-pug")
  use("bfrg/vim-jq")

  use({
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    -- commit = "668de0951a36ef17016074f1120b6aacbe6c4515",
    requires = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    run = function()
      vim.cmd("TSUpdate")
    end,
    config = function()
      require("kraftwerk28.plugins.treesitter")
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    requires = { "b0o/schemastore.nvim" },
    -- "~/projects/neovim/nvim-lspconfig",
    config = function()
      require("kraftwerk28.plugins.lsp_servers")
    end,
  })

  use({
    "RRethy/vim-illuminate",
    disable = true,
    config = function()
      local utils = require("kraftwerk28.config.utils")
      utils.highlight({ "illuminatedWord", guibg = "#303030" })
    end,
  })

  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("kraftwerk28.plugins.luasnip")
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-calc",
      "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("kraftwerk28.plugins.cmp")
    end,
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("kraftwerk28.plugins.nvimtree")
    end,
  })

  use({ "equalsraf/neovim-gui-shim", opt = true })

  -- use {
  --   "ray-x/lsp_signature.nvim",
  --   config = function()
  --     require("lsp_signature").setup {
  --       floating_window = true,
  --       floating_window_above_cur_line = false,
  --       hint_enable = false,
  --     }
  --   end,
  -- }

  use({
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set("v", "<Leader>ea", "<Plug>(EasyAlign)")
    end,
  })
  use({ "mfussenegger/nvim-dap" })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("kraftwerk28.plugins.null_ls")
    end,
  })

  use({
    "nvim-neorg/neorg",
    disable = true,
    requires = { "nvim-lua/plenary.nvim" },
    after = { "nvim-treesitter" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                my_workspace = "~/notes",
              },
            },
          },
        },
      })
    end,
  })

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      local fn = [[
        function! MkdpOpenInNewWindow(url) abort
          execute 'silent !firefox -ssb --new-window ' .. a:url
        endfunction
      ]]
      vim.api.nvim_exec(fn, false)
      vim.g.mkdp_browserfunc = "MkdpOpenInNewWindow"
    end,
  })

  use({
    -- "github/copilot.vim",
    "~/projects/neovim/copilot.vim",
    disable = true,
  })

  use({
    "Shatur/neovim-session-manager",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local c = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = c.AutoloadMode.Disabled,
      })
    end,
  })
end

local function bootstrap()
  local fn, api = vim.fn, vim.api
  local packer_install_path = fn.stdpath("data")
    .. "/site/pack/packer/opt/packer.nvim"
  local not_installed = fn.empty(fn.glob(packer_install_path)) == 1

  if not_installed then
    print("`packer.nvim` is not installed, installing...")
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_install_path,
    })
  end

  vim.cmd("packadd packer.nvim")
  require("packer").startup({
    load,
    config = {
      git = { clone_timeout = 240 },
      autoremove = true,
    },
  })
  api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/plugins/init.lua",
    callback = function(arg)
      vim.cmd("source " .. arg.file)
      vim.cmd("PackerCompile")
    end,
  })
  if not_installed then
    require("packer").sync()
  end
end

return bootstrap
