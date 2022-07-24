local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local api = vim.api

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
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "calc" },
    { name = "path", max_item_count = 8 },
    {
      name = "buffer",
      option = {
        -- use only buffers from current tabpage, but omit manpages as they can
        -- slow down neovim by being too large
        get_bufnrs = function()
          local ret = {}
          for _, winid in ipairs(api.nvim_tabpage_list_wins(0)) do
            local bufnr = api.nvim_win_get_buf(winid)
            local ft = api.nvim_buf_get_option(bufnr, "filetype")
            if ft ~= "man" then
              table.insert(ret, bufnr)
            end
          end
          return ret
        end,
      },
      max_item_count = 8,
      keyword_length = 5,
    },
  }),
  window = {
    documentation = {
      border = vim.g.floatwin_border,
    },
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
    return vim.o.buftype ~= "prompt"
      and vim.o.filetype ~= "asm"
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
})

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
