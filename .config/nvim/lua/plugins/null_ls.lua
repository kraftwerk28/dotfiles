local null_ls = require("null-ls")
local b = null_ls.builtins

null_ls.setup {
  sources = {
    b.diagnostics.eslint_d,
    b.formatting.eslint_d,
    b.diagnostics.luacheck.with {
      args = {
          "--formatter", "plain",
          "--codes",
          "--ranges",
          "--globals", "vim",
          "--filename", "$FILENAME",
          "-",
      },
    },
    b.hover.dictionary.with {
      filetypes = {"markdown"},
    },
    b.formatting.prettier.with {
      filetypes = {"graphql"},
    },
  },
}
