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
  ls.snippet(
    "once",
    fmt.fmta(
      [[
        #ifndef <hdr>
        #define <hdr>

        <>

        #endif
      ]],
      {
        hdr = f(function()
          local file = vim.fn.expand("%:t:r")
          return file:gsub("%p", "_"):upper() .. "_INCLUDED"
        end),
        i(0),
      }
    )
  ),
}

ls.add_snippets("go", {
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
})

ls.add_snippets("javascript", ecma_snippets)
ls.add_snippets("javascriptreact", ecma_snippets)
ls.add_snippets("typescript", ecma_snippets)
ls.add_snippets("typescriptreact", ecma_snippets)
ls.add_snippets("svelte", ecma_snippets)

ls.add_snippets("python", {
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
})

ls.add_snippets("c", c_cpp_snippets)
ls.add_snippets("cpp", c_cpp_snippets)

ls.add_snippets("all", {
  ls.snippet({
    trig = "uuid",
    dscr = { "Generate UUID using `uuidgen`" },
  }, {
    f(function()
      local raw = vim.fn.system("uuidgen")
      return vim.trim(raw)
    end),
  }),

  ls.snippet({
    trig = "unixnow",
    dscr = { "Current UNIX epoch" },
  }, {
    f(function()
      local raw = vim.fn.system("date +%s")
      return vim.trim(raw)
    end),
  }),
})

-- require("luasnip.loaders.from_snipmate").lazy_load()
-- ls.filetype_extend("all", { "_" })

local opt = { silent = true, expr = true }

vim.keymap.set({ "s", "i" }, "<C-L>", function()
  if ls.expand_or_jumpable() then
    return "<Plug>luasnip-expand-or-jump"
  else
    return "<C-L>"
  end
end, opt)

vim.keymap.set({ "s", "i" }, "<C-H>", function()
  if ls.jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  else
    return "<C-H>"
  end
end, opt)

vim.keymap.set({ "s", "i" }, "<C-;>", function()
  if ls.choice_active() then
    return "<Plug>luasnip-next-choice"
  else
    return "<C-;>"
  end
end, opt)
