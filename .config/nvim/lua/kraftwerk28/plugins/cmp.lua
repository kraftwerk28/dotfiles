local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

-- cmp.register_source(
--   "conventional_commit",
--   require("kraftwerk28.cmp_conventional_commit")
-- )

cmp.setup({
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
        -- use only buffers from current tabpage, but omit help/manpages as
        -- they usually contain too much words
        get_bufnrs = function()
          local ret = {}
          for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local bufnr = vim.api.nvim_win_get_buf(winid)
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
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
    format = lspkind.cmp_format({
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
      luasnip.lsp_expand(args.body)
    end,
  },
  -- view = {
  --   entries = "native",
  -- },
})
