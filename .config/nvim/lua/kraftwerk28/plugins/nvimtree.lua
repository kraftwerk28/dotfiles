local nt = require("nvim-tree")

m("n", "<F3>", function()
  if vim.o.filetype == "NvimTree" then
    return ":NvimTreeClose<CR>"
  else
    return ":NvimTreeOpen<CR>"
  end
end, { silent = true, expr = true })

m("n", "<Leader><F3>", function()
  if vim.o.filetype == "NvimTree" then
    return ":NvimTreeClose<CR>"
  else
    return ":NvimTreeFindFile<CR>"
  end
end, { silent = true, expr = true })

nt.setup({
  disable_netrw = false,
  hijack_netrw = true,
  hijack_cursor = true,
  git = {
    ignore = false,
  },
  view = {
    adaptive_size = true,
    number = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = false,
    },
  },
  renderer = {
    indent_markers = { enable = false },
    icons = {
      glyphs = {
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
})
