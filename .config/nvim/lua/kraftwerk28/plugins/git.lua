return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      -- "sindrets/diffview.nvim", -- optional - Diff integration
    },
    lazy = false,
    keys = {
      { "<Leader>gs", "<Cmd>Neogit<CR>" },
    },
    opts = {
      disable_hint = true,
      disable_insert_on_commit = true,
      graph_style = "unicode",
      kind = "auto",
      mappings = {
        status = {
          ["="] = "Toggle",
          ["}"] = false,
          ["{"] = false,
        },
      },
      signs = {
        item = { " ", " " },
        section = { " ", " " },
      },
    },
  },

  {
    "linrongbin16/gitlinker.nvim",
    lazy = false,
    opts = {
      -- router = {
      --   -- browse = {},
      --   browse = setmetatable({
      --     ["bruh%.com$"] = [[bruh]],
      --   }, {
      --     __index = function(_, key)
      --       vim.print(key)
      --       vim.print(require "gitlinker.configs".get())
      --       local configs = require "gitlinker.configs"
      --       local builtin = (configs.router or {}).browse or {}
      --       return vim.g.gitlinker_router.browse[key] or builtin[key]
      --     end,
      --   }),
      -- },
    },
    keys = {
      { "<Leader>gb", "<Cmd>GitLink<CR>", mode = { "n", "v" } },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
