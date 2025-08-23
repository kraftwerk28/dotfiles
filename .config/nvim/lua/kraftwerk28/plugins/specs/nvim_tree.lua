return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
  opts = {
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
      local api = require "nvim-tree.api"
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
  },
  keys = function()
    local api = require "nvim-tree.api"
    return {
      {
        "<F3>",
        function()
          if vim.bo.filetype == "NvimTree" then
            api.tree.close()
          else
            api.tree.open()
          end
        end,
        mode = "n",
        desc = "Toggle nvim-tree",
      },
      {
        "<Leader><F3>",
        function()
          api.tree.open({ find_file = true })
        end,
        mode = "n",
        desc = "Open/focus nvim-tree, revealing current buffer in tree",
      },
    }
  end,
}
