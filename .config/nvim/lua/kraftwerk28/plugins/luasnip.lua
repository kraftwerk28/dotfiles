require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node
local rep = extras.rep
local d = ls.dynamic_node

-- ls.filetype_extend("all", { "_" })

local ecma_snippets = {
  ls.snippet(
    "usest",
    fmt.fmta("const [<>, <>] = useState(<>);", {
      i(1),
      f(function(args)
        local s = args[1][1]
        return "set" .. s:sub(1, 1):upper() .. s:sub(2)
      end, { 1 }),
      i(0),
    })
  ),
  ls.snippet(
    "tsignore",
    c(1, { t("// @ts-expect-error"), t("// @ts-ignore") })
  ),
}

local c_cpp_snippets = {
  ls.snippet(
    "main",
    fmt.fmta(
      [[
        int main(<args>) {
        <ind><cursor>
        <ind>return 0;
        }
      ]],
      {
        args = c(1, { t("int argc, char *argv[]"), t("void") }),
        ind = t("\t"),
        cursor = i(0),
      }
    )
  ),
  ls.snippet(
    "fori",
    fmt.fmta(
      [[
        for (<> <> = 0; <> << <>; <>++) {
        <><>
        }
      ]],
      { i(1, "int"), i(2, "i"), rep(2), i(3, "42"), rep(2), t("\t"), i(0) }
    )
  ),
}

ls.add_snippets(nil, {
  go = {
    ls.snippet("ie", {
      t("if "),
      c(1, {
        fmt.fmta("<> != nil", { i(1, "err") }),
        fmt.fmta("<> = <>; <> != nil", { i(2, "err"), i(1), rep(2) }),
        fmt.fmta("<> := <>; <> != nil", { i(2, "err"), i(1), rep(2) }),
      }),
      t({ " {", "\t" }),
      i(0),
      t({ "", "}" }),
    }),
    ls.snippet(
      "main",
      fmt.fmta(
        [[
        func main() {
        <><>
        }
      ]],
        { t("\t"), i(0) }
      )
    ),
  },
  javascript = ecma_snippets,
  javascriptreact = ecma_snippets,
  typescript = ecma_snippets,
  typescriptreact = ecma_snippets,
  svelte = ecma_snippets,
  python = {
    ls.snippet("ifmain", {
      t("if __name__ == "),
      c(1, { t('"__main__"'), t("'__main__'") }),
      t({ ":", "\t" }),
      i(0),
    }),
    ls.snippet(
      "dundermethod",
      fmt.fmta(
        [[
          def __<>__(self<>):
          <><>
        ]],
        { i(1, "init"), i(2), t("\t"), i(0) }
      )
    ),
  },
  c = c_cpp_snippets,
  cpp = c_cpp_snippets,
  all = {
    ls.snippet("lorem", t("Lorem ipsum dolor sit amet")),
  },
}, { key = "mysnippets" })

ls.config.set_config({
  -- history = true,
  updateevents = "TextChanged,TextChangedI",
})

m:withopt({ silent = true, expr = true }, function()
  m({ "s", "i" }, "<C-L>", function()
    if ls.expand_or_jumpable() then
      return "<Plug>luasnip-expand-or-jump"
    else
      return "<C-L>"
    end
  end)

  m({ "s", "i" }, "<C-H>", function()
    if ls.jumpable(-1) then
      return "<Plug>luasnip-jump-prev"
    else
      return "<C-H>"
    end
  end)

  m({ "s", "i" }, "<C-;>", function()
    if ls.choice_active() then
      return "<Plug>luasnip-next-choice"
    else
      return "<C-;>"
    end
  end)
end)
