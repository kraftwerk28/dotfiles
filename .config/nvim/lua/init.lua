function setup_treesitter()
  local ts = require'nvim-treesitter.configs'
  ts.setup {
    -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
    ensure_installed = 'maintained',
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "dart", "ocaml", "java", "clojure" }, -- list of language that will be disabled
    },
    indent = { enable = true },
  }
end

function setup_lsp()
  local lsp = require'lspconfig'
  local attach = require'completion'.on_attach

  lsp.tsserver.setup{
    cmd = {
      'typescript-language-server',
      '--stdio',
    },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    root_dir = lsp.util.root_pattern(
      'package.json',
      'tsconfig.json',
      '.git'
    ),
    on_attach = attach
  }
end

pcall(setup_treesitter)
-- pcall(setup_lsp)
