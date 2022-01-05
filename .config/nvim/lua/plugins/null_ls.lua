local b = require("null-ls.builtins")
local u = require("null-ls.utils")

require("null-ls").setup {
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
    b.code_actions.eslint_d,
  },
  root_dir = u.root_pattern(
    ".null-ls-root",
    "Makefile",
    ".git",
    ".eslintrc*"
  ),
}
