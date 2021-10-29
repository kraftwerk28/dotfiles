local cmp = require("cmp")
local lspkind = require("lspkind")
local m = cmp.mapping

cmp.setup {
  mapping = {
    ["<Tab>"]     = m.select_next_item(),
    ["<S-Tab>"]   = m.select_prev_item(),
    ["<C-Space>"] = cmp.mapping(m.complete(), {"i", "c"}),
    ["<CR>"]      = m.confirm({select = false}),
  },
  sources = {
    {name = "nvim_lsp" },
    {
      name = "buffer",
      opts = {
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\|[а-яА-ЯеёЕЁ]*\)]],
      }
    },
    {name = "path"     },
    {name = "ultisnips"},
  },
  documentation = {
    border = vim.g.floatwin_border,
  },
  preselect = cmp.PreselectMode.None,
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Insert,
  },
  formatting = {
    format = function(_ --[[entry]], vim_item)
      local icon = lspkind.presets.default[vim_item.kind]
      vim_item.abbr = icon.." "..vim_item.abbr
      return vim_item
    end,
  },
  -- experimental = {
  --   native_menu = true,
  -- },
  enabled = function()
    return
      vim.bo.buftype ~= "prompt"
      and vim.bo.filetype ~= "asm"
      and vim.fn.win_gettype() == ""
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
