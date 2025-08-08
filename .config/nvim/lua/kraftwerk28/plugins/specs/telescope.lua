return {
  "nvim-telescope/telescope.nvim",
  -- "~/projects/neovim/telescope.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  init = function() end,
  keys = function()
    local builtin = require "telescope.builtin"
    return {
      {
        "<C-W>",
        "<C-S-W>",
        mode = "i",
        ft = "TelescopePrompt",
      },
      {
        "<C-BS>",
        "<C-S-W>",
        mode = "i",
        ft = "TelescopePrompt",
      },

      {
        "<C-P>",
        function()
          builtin.find_files {
            find_command = function(opts)
              return {
                "fd",
                "--type=file",
                "--color=never",
                "--exclude=.git",
              }
            end,
            previewer = false,
            theme = "dropdown",
            hidden = true,
          }
        end,
      },

      {
        "<Leader>rg",
        function()
          builtin.live_grep {
            additional_args = {
              -- NOTE: --sort slows it down
              -- "--sort=path",
              "--hidden",
              "--glob=!.git/",
            },
          }
        end,
      },

      -- Like live_grep, but no regex
      -- vim.keymap.set("n", "<Leader>rs", builtin.live_grep)
      {
        "<Leader>rs",
        function()
          builtin.live_grep {
            additional_args = {
              -- NOTE: --sort slows it down
              -- "--sort=path",
              "--hidden",
              "--glob=!.git/",
              "--fixed-strings",
            },
          }
        end,
      },

      { "<F1>", builtin.help_tags },
      {
        "<Leader>da",
        builtin.diagnostics,
        desc = "[D]iagnostics [A]ll",
      },
      {
        "<F4>",
        function()
          builtin.symbols { sources = { "math" } }
        end,
      },
      {
        "<Leader>ma",
        function()
          builtin.man_pages { sections = { "ALL" } }
        end,
      },
    }
  end,
  opts = function()
    local actions = require "telescope.actions"
    return {
      defaults = {
        -- borderchars = (function()
        --   -- Telescope has slightly different borderchar array format
        --   local a, b, c, d, e, f, g, h = unpack(vim.g.borderchars)
        --   return { b, d, f, h, a, c, e, g }
        -- end)(),
        sorting_strategy = "ascending",
        prompt_prefix = " ",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        selection_caret = " ",
        scroll_strategy = "cycle",
        mappings = {
          i = {
            ["<C-K>"] = actions.move_selection_previous,
            ["<C-J>"] = actions.move_selection_next,
            ["<Esc>"] = actions.close,
          },
        },
      },
      extensions = {
        tele_tabby = {
          use_highlighter = true,
        },
      },
    }
  end,
}
