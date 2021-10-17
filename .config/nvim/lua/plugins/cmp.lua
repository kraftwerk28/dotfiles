local cmp = require("cmp")
local lspkind = require("lspkind")
local maps = cmp.mapping

cmp.setup {
  mapping = {
    ["<Tab>"]     = maps.select_next_item(),
    ["<S-Tab>"]   = maps.select_prev_item(),
    ["<C-Space>"] = maps.complete(),
    ["<CR>"]      = maps.confirm(),
  },
  sources = {
    {name = "nvim_lsp" },
    {name = "buffer"   },
    {name = "path"     },
    {name = "ultisnips"},
  },
  documentation = {
    border = vim.g.floatwin_border,
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    format = function(entry, vim_item)
      local icon = lspkind.presets.default[vim_item.kind]
      vim_item.abbr = icon.." "..vim_item.abbr
      return vim_item
    end,
  },
  experimental = {
    native_menu = true,
  },
  enabled = function()
    return vim.bo.buftype ~= "prompt" and vim.bo.filetype ~= "asm"
  end,
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
