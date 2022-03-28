-- Parse vim-snippets
require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node

ls.filetype_extend("all", { "_" })

local go_iferr = ls.snippet(
  "ie",
  {
    t{"if "},
    c(1, {
      fmt.fmta("<> != nil", { i(1, "err") }),
      fmt.fmta("<> = <>; <> != nil", { i(2, "err"), i(1), extras.rep(2) }),
      fmt.fmta("<> := <>; <> != nil", { i(2, "err"), i(1), extras.rep(2) }),
    }),
    t{" {", "\t"}, i(0), t{"", "}"},
  }
)

local js_usestate = ls.snippet(
  "usest",
  fmt.fmta("const [<>, <>] = useState(<>);", {
    i(1),
    f(function(args)
      local w = args[1][1]
      return "set"..w:sub(1, 1):upper()..w:sub(2)
    end, {1}),
    i(0),
  })
)

ls.snippets = {
  go = { go_iferr },
  javascript = { js_usestate },
  typescript = { js_usestate },
  typescriptreact = { js_usestate },
}

vim.keymap.set({"s", "i"}, "<C-J>", "<Plug>luasnip-jump-next", { noremap = true })
vim.keymap.set({"i", "s"}, "<C-K>", function()
  if ls.jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  else
    return "<C-K>"
  end
end, { noremap = true, expr = true })
vim.keymap.set({"s", "i"}, "<C-L>", "<Plug>luasnip-expand-or-jump", { noremap = true })
vim.keymap.set({"s", "i"}, "<C-;>", "<Plug>luasnip-next-choice", { noremap = true })
