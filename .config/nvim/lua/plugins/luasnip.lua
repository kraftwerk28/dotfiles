-- Parse vim-snippets
-- require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local rep = extras.rep

-- ls.filetype_extend("all", { "_" })

ls.add_snippets("go", {
  ls.snippet(
    "ie",
    {
      t("if "),
      c(1, {
        fmt.fmta("<> != nil", { i(1, "err") }),
        fmt.fmta("<> = <>; <> != nil", { i(2, "err"), i(1), rep(2) }),
        fmt.fmta("<> := <>; <> != nil", { i(2, "err"), i(1), rep(2) }),
      }),
      t({ " {", "\t" }),
      i(0),
      t({ "", "}" })
    }
  )
})

local ecma_snippets = {
  ls.snippet(
    "usest",
    fmt.fmta("const [<>, <>] = useState(<>);", {
      i(1),
      f(function(args)
        local s = args[1][1]
        return "set"..s:sub(1, 1):upper()..s:sub(2)
      end, { 1 }),
      i(0),
    })
  ),
  ls.snippet("cl", fmt.fmta("console.log(<>)", i(0))),
}

ls.add_snippets("javascript", ecma_snippets)
ls.add_snippets("javascriptreact", ecma_snippets)
ls.add_snippets("typescript", ecma_snippets)
ls.add_snippets("typescriptreact", ecma_snippets)

ls.config.set_config({
  -- history = true,
  updateevents = "TextChanged,TextChangedI",
})

vim.keymap.set({"s", "i"}, "<C-L>", function()
  if ls.expand_or_jumpable() then
    vim.schedule(ls.expand_or_jump)
    return "<Plug>luasnip-expand-or-jump"
  else
    return "<C-L>"
  end
end, { silent = true, expr = true })

vim.keymap.set({"s", "i"}, "<C-H>", function()
  if ls.jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  else
    return "<C-H>"
  end
end, { silent = true, expr = true })

vim.keymap.set({"s", "i"}, "<C-;>", function()
  if ls.choice_active() then
    return "<Plug>luasnip-next-choice"
  else
    return "<C-;>"
  end
end, { silent = true, expr = true })
