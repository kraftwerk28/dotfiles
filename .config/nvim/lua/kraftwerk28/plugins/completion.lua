return {
  {
    "saghen/blink.cmp",
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
          auto_brackets = {
            enabled = false,
          },
        },
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
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
        default = { "lsp", "snippets", "path", "buffer" },
        per_filetype = {
          tex = { "omni", "snippets", "path", "buffer" },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      snippets = {
        preset = "luasnip",
      },
      signature = {
        enabled = true,
      },
      cmdline = {
        enabled = false,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-calc",
      "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require "cmp"
      return {
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-N>"] = cmp.mapping.select_next_item(),
          ["<C-P>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
          { name = "conventional_commit" },
          { name = "nvim_lsp" },
          { name = "luasnip", max_item_count = 8 },
          { name = "calc" },
          { name = "path", max_item_count = 8 },
          {
            name = "buffer",
            option = {
              -- Omit man/help buffers as they are usually too large and slow down
              -- the whole thing
              get_bufnrs = function()
                local ret = {}
                for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                  local bufnr = vim.api.nvim_win_get_buf(winid)
                  local ft = vim.bo[bufnr].filetype
                  if ft ~= "man" and ft ~= "help" then
                    table.insert(ret, bufnr)
                  end
                end
                return ret
              end,
            },
            max_item_count = 10,
            keyword_length = 5,
          },
        }),
        window = {
          documentation = {
            border = vim.g.borderchars,
          },
        },
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = require "lspkind".cmp_format({
            mode = "text",
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[lsp]",
              path = "[path]",
              luasnip = "[snip]",
              calc = "[calc]",
              conventional_commit = "[convcommit]",
            },
          }),
        },
        -- enabled = function()
        --   if vim.fn.win_gettype() ~= "" then
        --     return false
        --   end
        --   if vim.bo.filetype == "asm" then
        --     return false
        --   end
        --   if vim.bo.buftype == "prompt" then
        --     return false
        --   end
        --   return true
        -- end,
        snippet = {
          expand = function(args)
            require "luasnip".lsp_expand(args.body)
          end,
        },
        -- view = {
        --   entries = "native",
        -- },
      }
    end,
  },
}
