-- Parse vim-snippets
-- require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node

-- ls.filetype_extend("all", { "_" })
local function capitalize(s)
  return s:sub(1, 1):upper()..s:sub(2)
end

local go_iferr = ls.snippet(
  "ie",
  {
    t({"if "}),
    c(1, {
      fmt.fmta("<> != nil", { i(1, "err") }),
      fmt.fmta("<> = <>; <> != nil", { i(2, "err"), i(1), extras.rep(2) }),
      fmt.fmta("<> := <>; <> != nil", { i(2, "err"), i(1), extras.rep(2) }),
    }),
    t({" {", "\t"}), i(0), t({"", "}"}),
  }
)

local ecma_snips = {
  ls.snippet(
    "usest",
    fmt.fmta("const [<>, <>] = useState(<>);", {
      i(1),
      f(function(args) return "set"..capitalize(args[1][1]) end, {1}),
      i(0),
    })
  ),
  ls.snippet("cl", fmt.fmta("console.log(<>)", i(0))),
}

local snippets = {
  go = { go_iferr },
  javascript = { unpack(ecma_snips) },
  typescript = { unpack(ecma_snips) },
  typescriptreact = { unpack(ecma_snips) },
}

ls.add_snippets(nil, snippets)

do
  vim.keymap.set({"s", "i"}, "<C-J>", "<Plug>luasnip-jump-next")
  vim.keymap.set(
    {"i", "s"}, "<C-K>",
    function()
      if ls.jumpable(-1) then
        return "<Plug>luasnip-jump-prev"
      else
        return "<C-K>"
      end
    end,
    { expr = true }
  )
  vim.keymap.set({"s", "i"}, "<C-L>", "<Plug>luasnip-expand-or-jump")
  vim.keymap.set({"s", "i"}, "<C-;>", "<Plug>luasnip-next-choice")
end
