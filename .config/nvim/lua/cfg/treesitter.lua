local ts_configs = require'nvim-treesitter.parsers'.get_parser_configs()

ts_configs.elixir = {
  install_info = {
    url = '~/projects/treesitter/tree-sitter-elixir',
    files = {'src/parser.c'},
  },
  filetype = 'elixir',
}

local disabled = {
  'dart', 'ocaml', 'java', 'clojure', 'gdscript', 'ocamllex', 'fennel',
  'verilog', 'sparql', 'turtle', 'teal',
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {enable = true, disable = disabled},
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
}
