return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      mode = "cursor",
    },
  },
  {
    -- "~/projects/neovim/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter",
    -- commit = "668de0951a36ef17016074f1120b6aacbe6c4515",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
    },
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local config = {
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>)",
            node_incremental = ")",
            node_decremental = "(",
          },
        },
        blockmark = {
          enable = true,
        },
        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true,
        --     lookbehind = true,
        --     keymaps = {
        --       ["aa"] = "@parameter.outer",
        --       ["ia"] = "@parameter.inner",
        --       ["ib"] = "@block.inner",
        --       ["ab"] = "@block.outer",
        --     },
        --   },
        --   move = {
        --     enable = true,
        --   },
        -- },
      }

      if vim.fn.has("win64") == 1 then
        config.ensure_installed = {
          "java",
          "kotlin",
          "javascript",
          "lua",
          "python",
        }
      elseif vim.fn.has("unix") == 1 then
        config.ensure_installed = "all"
        config.ignore_install = { "ipkg" }
      end

      require("nvim-treesitter.configs").setup(config)
    end,
    init = function()
      -- Disable semantic highlight of `#if`, `#ifdef` etc
      vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
    end,
  },
}
