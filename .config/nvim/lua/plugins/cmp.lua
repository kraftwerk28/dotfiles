local cmp = require"cmp"
local lspkind = require"lspkind"
local api = vim.api
local luasnip = require("luasnip")

-- snippy.setup {
--   mappings = {
--     is = {
--       ["<C-K>"] = "previous",
--       ["<C-J>"] = "next",
--     },
--   },
-- }

cmp.setup {
  mapping = {
    ["<Tab>"]     = cmp.mapping.select_next_item(),
    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    {
      name = "buffer",
      option = {
        -- Uses only buffers from current tabpage
        get_bufnrs = function()
          return vim.tbl_map(
            function(w) return api.nvim_win_get_buf(w) end,
            api.nvim_tabpage_list_wins(0)
          )
        end,
      },
    },
    { name = "path" },
    { name = "luasnip" },
    { name = "calc" },
  },
  documentation = {
    border = vim.g.floatwin_border,
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    format = lspkind.cmp_format(),
    -- format = function(entry, vim_item)
    --   return lspkind.cmp_format()
    --   -- local icon = lspkind.presets.default[vim_item.kind]
    --   -- vim_item.abbr = icon.." "..vim_item.abbr
    --   -- return vim_item
    -- end,
  },
  enabled = function()
    return vim.bo.buftype ~= "prompt"
       and vim.bo.filetype ~= "asm"
       and vim.fn.win_gettype() == ""
  end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  view = {
    entries = "native",
  },
}

--[[
local compe = require("compe")
compe.setup {
  throttle_time = 200,
  preselect = "disable",
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    ultisnips = true,
  },
  documentation = {border = vim.g.floatwin_border},
}
]]
