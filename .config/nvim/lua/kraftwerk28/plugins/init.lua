local function load(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "~/projects/neovim/gtranslate.nvim",
    -- "kraftwerk28/gtranslate.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Themes
  use("navarasu/onedark.nvim")
  -- use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  -- use("~/projects/neovim/nvim-base16")
  use("RRethy/nvim-base16")
  use({ "projekt0n/github-nvim-theme" })
  use({ "rebelot/kanagawa.nvim" })

  use({ "kyazdani42/nvim-web-devicons" })

  use({
    "tpope/vim-surround",
    config = function()
      local surr = setmetatable({}, {
        __newindex = function(_, k, v)
          vim.g["surround_" .. vim.fn.char2nr(k)] = v
        end,
      })
      surr["r"] = "{'\r'}"
      surr["j"] = "{/* \r */}"
      surr["c"] = "/* \r */"
      surr["l"] = "[[\r]]"
      surr["i"] = "\1before: \1\r\2after: \2"
    end,
  })

  use({
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language(
        "default",
        { prefer_single_line_comments = true }
      )
      m:withopt({ silent = true, remap = true }, function()
        m("n", "<C-/>", "gcc")
        m("i", "<C-/>", "<C-O>:normal gcc<CR>")
        m("x", "<C-/>", "gcgv")
      end)
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
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          border = vim.g.borderchars,
        },
      })
    end,
  })

  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb", "tommcdo/vim-fubitive" },
    config = function()
      m:withopt({ silent = true }, function()
        m("n", "<Leader>gs", "<Cmd>vert Git<CR>")
        m({ "n", "v" }, "<Leader>gb", ":GBrowse<CR>")

        -- Merge conflicts
        m("n", "<Leader>gm", "<Cmd>Gdiffsplit!<CR>")
        m("n", "<Leader>gh", "<Cmd>diffget //2<CR>")
        m("n", "<Leader>gl", "<Cmd>diffget //3<CR>")
      end)
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
      require("kraftwerk28.lsp.servers")
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
      require("kraftwerk28.plugins.nvim-tree")
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

  use({
    "mfussenegger/nvim-dap",
    config = function()
      require("kraftwerk28.plugins.dap")
    end,
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("kraftwerk28.plugins.null-ls")
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
    "Shatur/neovim-session-manager",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local c = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = c.AutoloadMode.Disabled,
      })
    end,
  })

  use({
    "p00f/clangd_extensions.nvim",
    config = function()
      require("clangd_extensions").setup()
    end,
  })

  use({
    -- "github/copilot.vim",
    "~/projects/neovim/copilot.vim",
    disable = true,
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
  local packer = require("packer")

  packer.startup({
    load,
    config = {
      git = { clone_timeout = 240 },
      autoremove = true,
    },
  })

  api.nvim_create_autocmd("BufWritePost", {
    pattern = "kraftwerk28/plugins/*.lua",
    callback = function(arg)
      vim.cmd("source " .. arg.file)
      packer.compile()
    end,
    group = api.nvim_create_augroup("packer", {}),
  })

  if not_installed then
    packer.sync()
  end
end

return bootstrap
