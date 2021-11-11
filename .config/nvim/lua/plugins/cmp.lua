local cmp = require("cmp")
local lspkind = require("lspkind")

-- local function custom_snippet_expand(args)
--   local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local line_text =
--     vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
--   local indent = string.match(line_text, '^%s*')
--   local replace = vim.split(args.body, '\n', true)
--   local surround = string.match(line_text, '%S.*') or ''
--   local surround_end = surround:sub(col)

--   replace[1] = surround:sub(0, col - 1)..replace[1]
--   replace[#replace] =
--     replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
--   if indent ~= '' then
--     for i, line in ipairs(replace) do
--       replace[i] = indent..line
--     end
--   end

--   vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
-- end

cmp.setup {
  mapping = {
    ["<Tab>"]     = cmp.mapping.select_next_item(),
    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({
      select = false,
    }),
  },
  sources = cmp.config.sources {
    {name = "nvim_lsp"},
    {
      name = "buffer",
      -- opts = {
      --   keyword_pattern =
      --     [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\|[а-яА-ЯеёЕЁ]*\)]]
      -- },
    },
    {name = "path"},
    -- {name = "ultisnips"},
    {name = 'luasnip'},
  },
  documentation = {
    border = vim.g.floatwin_border,
  },
  preselect = cmp.PreselectMode.None,
  -- confirmation = {
  --   default_behavior = cmp.ConfirmBehavior.Insert,
  -- },
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
  -- snippet = {
  --   expand = custom_snippet_expand,
  -- }
  snippet = {
    expand = function(args)
      -- vim.fn["UltiSnips#Anon"](args.body)
      require('luasnip').lsp_expand(args.body)
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
