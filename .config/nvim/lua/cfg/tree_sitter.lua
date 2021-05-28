-- LuaFormatter off
local disabled = {
    -- 'bash',
    'beancount',
    'bibtex',
    -- 'c',
    -- 'c_sharp',
    'clojure',
    -- 'comment',
    -- 'cpp',
    -- 'css',
    'dart',
    'devicetree',
    -- 'elm',
    -- 'erlang',
    'fennel',
    'fortran',
    'gdscript',
    'glimmer',
    -- 'go',
    -- 'graphql',
    -- 'haskell',
    -- 'html',
    -- 'java',
    -- 'javascript',
    -- 'jsdoc',
    -- 'json',
    -- 'jsonc',
    'julia',
    'kotlin',
    -- 'latex',
    'ledger',
    -- 'lua',
    'nix',
    'ocaml',
    'ocaml_interface',
    'ocamllex',
    'php',
    -- 'python',
    'ql',
    'query',
    'r',
    -- 'regex',
    -- 'rst',
    -- 'ruby',
    -- 'rust',
    'scala',
    -- 'scss',
    'sparql',
    'supercollider',
    -- 'svelte',
    'swift',
    'teal',
    -- 'toml',
    -- 'tsx',
    'turtle',
    -- 'typescript',
    -- 'verilog',
    'vue',
    -- 'yaml',
    'zig',
}
-- LuaFormatter on

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {enable = true, disable = disabled},
  playground = {
    enable = true,
    disable = disabled,
    updatetime = 25,
    persist_queries = false,
  },
  -- refactor = {
  --     highlight_definitions = {enable = true},
  --     highlight_current_scope = {enable = true},
  -- },
}
