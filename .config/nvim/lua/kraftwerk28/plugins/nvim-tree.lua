local nt = require("nvim-tree")
local api = require("nvim-tree.api")

m("n", "<F3>", function()
  api.tree.toggle()
end)

m("n", "<Leader><F3>", function()
  api.tree.toggle(true)
end)

nt.setup({
  -- disable_netrw = false,
  hijack_netrw = false,
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
        -- git = {
        --   unstaged = "✗",
        --   staged = "✓",
        --   unmerged = "",
        --   renamed = "➜",
        --   untracked = "",
        --   deleted = "",
        --   ignored = "",
        -- },
      },
    },
  },
  on_attach = function(bufnr)
    m:withopt({ buffer = bufnr }, function()
      -- Simulate ranger's behavior
      m("n", "h", api.node.open.edit)
      m("n", "l", api.node.open.edit)
    end)
  end,
})
