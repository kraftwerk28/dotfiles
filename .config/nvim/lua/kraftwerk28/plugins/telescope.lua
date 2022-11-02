local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- Erase word with <C-W> in floating window, like before
au("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    m:withopt({ buffer = true }, function()
      m("i", "<C-W>", "<C-S-W>")
      m("i", "<C-BS>", "<C-S-W>")
    end)
  end,
})

m("n", "<C-P>", builtin.find_files)
m("n", "<Leader>rg", builtin.live_grep)
m("n", "<Leader>b", builtin.buffers)
m("n", "<Leader>ad", builtin.diagnostics)
m("n", "<Leader>he", builtin.help_tags)

telescope.setup({
  defaults = {
    borderchars = (function()
      local a, b, c, d, e, f, g, h = unpack(vim.g.borderchars)
      return { b, d, f, h, a, c, e, g }
    end)(),
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
  pickers = {
    find_files = {
      previewer = false,
      theme = "dropdown",
      hidden = true, -- show hidden files
      no_ignore = false,
    },
    live_grep = {
      additional_args = function()
        return { "--sort", "path" }
      end,
    },
  },
  extensions = {
    tele_tabby = {
      use_highlighter = true,
    },
  },
})
