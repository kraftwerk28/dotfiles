local function setup_treesitter()
    local ts = require'nvim-treesitter.configs'
    ts.setup {
        -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
        ensure_installed = 'maintained',
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = { "dart", "ocaml", "java", "clojure" }, -- list of language that will be disabled
        },
        -- indent = { enable = true },
    }
end

local function setup_lsp()
    local lsp = require'lspconfig'
    -- local attach = require'completion'.on_attach

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
    }

    lsp.pyls.setup{
        cmd = {'pyls'},
        filetypes = {'python'},

        jedi_completion = {enabled = true},
        jedi_hover = {enabled = true},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},

        mccabe = {enabled = true, threshold = 15},
        preload = {enabled = true},

        pycodestyle = {enabled = true},
        pydocstyle = {
            enabled = false,
            match = '(?!test_).*\\.py',
            matchDir = '[^\\.].*',
        },

        rope_completion = {enabled = true},
        yapf = {enabled = true},
    }

    lsp.rust_analyzer.setup{}
    lsp.gopls.setup{}
    lsp.hls.setup{}
    lsp.sumneko_lua.setup{
      cmd = {'lua-language-server'},
    }
end

pcall(setup_treesitter)
pcall(setup_lsp)
