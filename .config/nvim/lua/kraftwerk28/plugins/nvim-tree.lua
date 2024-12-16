local nt = require("nvim-tree")
local api = require("nvim-tree.api")

vim.keymap.set("n", "<F3>", function()
  if vim.bo.filetype == "NvimTree" then
    api.tree.close()
  else
    api.tree.open()
  end
end, { desc = "Toggle nvim-tree" })

vim.keymap.set("n", "<Leader><F3>", function()
  api.tree.open({ find_file = true })
end, { desc = "Open/focus nvim-tree, revealing current buffer in tree" })

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
      quit_on_open = false,
      resize_window = false,
    },
  },
  renderer = {
    indent_markers = { enable = false },
    icons = {
      glyphs = {
        folder = {
          -- arrow_open = "",
          -- arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
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
    api.config.mappings.default_on_attach(bufnr)

    -- Simulate ranger keymaps
    local opt = { buffer = bufnr }

    vim.keymap.set("n", "o", "<Nop>", opt)

    vim.keymap.set("n", "h", function()
      local node = api.tree.get_node_under_cursor()
      if node.open then
        api.node.open.edit()
      else
        api.node.navigate.parent_close()
      end
    end, opt)

    vim.keymap.set("n", "l", function()
      local node = api.tree.get_node_under_cursor()
      if not node.open then
        api.node.open.edit()
      end
    end, opt)
  end,
})
