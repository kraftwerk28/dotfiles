return {
  "saghen/blink.cmp",
  enabled = true,
  dependencies = {
    -- "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  version = "1.*",
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback_to_mappings" },
      ["<S-Tab>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-K>"] = false,
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },
      documentation = {
        auto_show = true,
      },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
      -- menu = {
      --   draw = {
      --     columns = {
      --       { "kind_icon" },
      --       { "label", "label_description", gap = 1 },
      --     },
      --   },
      -- },
    },
    sources = {
      default = {
        "lsp",
        "snippets",
        "path",
        "buffer",
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
    cmdline = { enabled = false },
  },
}
