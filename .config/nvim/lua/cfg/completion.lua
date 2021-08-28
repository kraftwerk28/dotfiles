local cmp = require("cmp")
local lspkind = require("lspkind")
local maps = cmp.mapping

cmp.setup {
  mapping = {
    -- Plugin errors when this is empty
    ["<Tab>"] = maps.select_next_item(),
    ["<S-Tab>"] = maps.select_prev_item(),
    ["<C-Space>"] = maps.complete(),
    ["<CR>"] = maps.confirm(),
  },
  sources = {
    {name = "nvim_lsp"},
    {name = "buffer"},
    {name = "path"},
    {name = "ultisnips"},
  },
  documentation = {
    border = vim.g.floatwin_border
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
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
