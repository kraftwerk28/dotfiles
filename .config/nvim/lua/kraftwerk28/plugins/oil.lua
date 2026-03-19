return {
  "stevearc/oil.nvim",
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  opts = {
    default_file_explorer = true,
    -- keymaps = {
    --   ["h"] = { "actions.parent", mode = "n" },
    --   ["l"] = { "actions.select", mode = "n" },
    -- },
    columns = {
      "icon",
      "permissions",
    },
  },
  lazy = false,
  keys = {
    { "-", "<Cmd>Oil<CR>" },
  },
}
