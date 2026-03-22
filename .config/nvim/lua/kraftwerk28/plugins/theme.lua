local themes = {
  -- {
  --   "marko-cerovac/material.nvim",
  --   enabled = false,
  --   lazy = false,
  --   config = function() end,
  -- },

  {
    "navarasu/onedark.nvim",
    enabled = false,
    opts = {
      -- style = "dark",
    },
    config = function()
      require("onedark").load()
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    opts = {
      contrast = "", -- can be "hard", "soft" or empty string
      italic = {
        strings = false,
        folds = false,
      },
      -- overrides = {
      --   -- Search = { underdashed = true },
      --   -- CurSearch = { underdashed = true },
      --   StatusLine = { reverse = false },
      --   StatusLineNC = { reverse = false },
      -- },
    },
    init = function()
      vim.cmd.colorscheme "gruvbox"
    end,
  },

  -- {
  --   "sainnhe/gruvbox-material",
  --   lazy = false,
  --   enabled = false,
  --   config = function()
  --     vim.g.gruvbox_material_background = "medium"
  --     vim.g.gruvbox_material_foreground = "original"
  --     -- vim.g.gruvbox_material_enable_italic = true
  --     vim.cmd.colorscheme "gruvbox-material"
  --   end,
  -- },

  {
    "projekt0n/github-nvim-theme",
    enabled = false,
    config = function()
      -- NOTE: don't use `opts` for setup
      require("github-theme").setup {
        groups = {
          all = {
            TabLineSel = { link = "TabLine" },
          },
        },
      }
    end,
    init = function()
      vim.cmd.colorscheme "github_light"
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    opts = {
      -- background = {
      --   dark = "wave",
      --   light = "lotus",
      -- },
    },
    config = function()
      vim.cmd.colorscheme "kanagawa"
    end,
  },

  {
    "Shatur/neovim-ayu",
    enabled = false,
    opts = {
      mirage = true,
    },
    config = function(_, opts)
      require "ayu".setup(opts)
      vim.cmd.colorscheme "ayu"
    end,
  },
}

-- Set higher priority for themes (default 50) so they load before other plugins
for _, spec in ipairs(themes) do
  spec.lazy = false
  spec.priority = 100
end
return themes
