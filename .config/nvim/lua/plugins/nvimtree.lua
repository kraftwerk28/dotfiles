-- local utils = require("config.utils")
-- local highlight = utils.highlight

-- highlight { "NvimTreeFolderName", "Title" }
-- highlight { "NvimTreeFolderIcon", "Title" }

vim.g.nvim_tree_icons = {
  folder = {
    arrow_open   = "",
    arrow_closed = "",
    default      = "",
    open         = "",
    empty        = "",
    empty_open   = "",
    symlink      = "",
    symlink_open = "",
  },
  git = {
    unstaged  = "✗",
    staged    = "✓",
    unmerged  = "",
    renamed   = "➜",
    untracked = "",
    deleted   = "",
    ignored   = "",
  },
}

require("nvim-tree").setup({
  disable_netrw = false,
  hijack_netrw = true,
  hijack_cursor = true,
  git = {
    ignore = false
  },
  view = {
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
  },
})
