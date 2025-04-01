local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- Erase word with <C-W> in floating window, like before
autocmd("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.keymap.set("i", "<C-W>", "<C-S-W>", { buffer = true })
    vim.keymap.set("i", "<C-BS>", "<C-S-W>", { buffer = true })
  end,
})

vim.keymap.set("n", "<C-P>", function()
  builtin.find_files({
    find_command = {
      "fd",
      "--type=file",
      "--color=never",
      "--exclude=.git",
    },
    previewer = false,
    theme = "dropdown",
    hidden = true,
    -- no_ignore = false,
  })
end)

vim.keymap.set("n", "<Leader>rg", function()
  builtin.live_grep({
    additional_args = {
      -- NOTE: --sort slows it down
      -- "--sort=path",
      "--hidden",
      "--glob=!.git/",
    },
  })
end)

-- Like live_grep, but no regex
-- vim.keymap.set("n", "<Leader>rs", builtin.live_grep)
vim.keymap.set("n", "<Leader>rs", function()
  builtin.live_grep({
    additional_args = {
      -- NOTE: --sort slows it down
      -- "--sort=path",
      "--hidden",
      "--glob=!.git/",
      "--fixed-strings",
    },
  })
end)

vim.keymap.set("n", "<F1>", builtin.help_tags)

vim.keymap.set("n", "<Leader>da", builtin.diagnostics, {
  desc = "[D]iagnostics [A]ll",
})

vim.keymap.set("n", "<F4>", function()
  require "telescope.builtin".symbols { sources = { "math" } }
end)

telescope.setup({
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
})
