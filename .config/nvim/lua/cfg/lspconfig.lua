local utils = require 'utils'
local lsp_config = require 'lspconfig'
local root_pattern = require'lspconfig.util'.root_pattern

local lsp = vim.lsp
local highlight = utils.highlight
local u = utils.u

highlight {'LspDiagnosticsUnderlineHint', gui = 'undercurl'}
highlight {'LspDiagnosticsUnderlineInformation', gui = 'undercurl'}
highlight {
    'LspDiagnosticsUnderlineWarning',
    gui = 'undercurl',
    guisp = 'orange',
}
highlight {'LspDiagnosticsUnderlineError', gui = 'undercurl', guisp = 'red'}
highlight {'LspDiagnosticsDefaultHint', fg = 'yellow'}
highlight {'LspDiagnosticsDefaultInformation', fg = 'lightblue'}
highlight {'LspDiagnosticsDefaultWarning', fg = 'orange'}
highlight {'LspDiagnosticsDefaultError', fg = 'red'}

local lsp_signs = {
    LspDiagnosticsSignHint = {
        text = u 'f0eb',
        texthl = 'LspDiagnosticsSignHint',
    },
    LspDiagnosticsSignInformation = {
        text = u 'f129',
        texthl = 'LspDiagnosticsSignInformation',
    },
    LspDiagnosticsSignWarning = {
        text = u 'f071',
        texthl = 'LspDiagnosticsSignWarning',
    },
    LspDiagnosticsSignError = {
        text = u 'f46e',
        texthl = 'LspDiagnosticsSignError',
    },
}

for hl_group, config in pairs(lsp_signs) do vim.fn.sign_define(hl_group, config) end

lsp_config.tsserver.setup {
    root_dir = root_pattern(
      'package.json', 'tsconfig.json', 'jsconfig.json', '.git', vim.fn.getcwd()
    ),
}

-- lsp_config.pyls.setup {
-- 	cmd = {'pyls'},
-- 	filetypes = {'python'},
-- 	settings = {
-- 		pyls = {
-- 			plugins = {
-- 				jedi_completion = {enabled = true},
-- 				jedi_hover = {enabled = true},
-- 				jedi_references = {enabled = true},
-- 				jedi_signature_help = {enabled = true},
-- 				jedi_symbols = {enabled = true, all_scopes = true},
-- 				yapf = {enabled = false},
-- 				pylint = {enabled = false},
-- 				pycodestyle = {enabled = false},
-- 				pydocstyle = {enabled = false},
-- 				mccabe = {enabled = false},
-- 				preload = {enabled = false},
-- 				rope_completion = {enabled = false},
-- 			},
-- 		},
-- 	},
-- }

lsp_config.pyright.setup {}

lsp_config.sumneko_lua.setup {
    cmd = {
        'lua-language-server', '-E', '/usr/share/lua-language-server/main.lua',
        '--logpath', vim.lsp.get_log_path():match '(.*[/\\])',
    },
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {globals = {'vim', 'dump'}},
            workspace = {
                library = {
                    [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                    [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
                },
            },
        },
    },
}

lsp_config.rust_analyzer.setup {}

lsp_config.gopls.setup {
    cmd = {'gopls', 'serve'},
    filetypes = {'go', 'gomod'},
    root_dir = root_pattern('go.mod', '.git', vim.fn.getcwd()),
}

lsp_config.hls.setup {
    settings = {haskell = {formattingProvider = 'brittany'}},
    root_dir = root_pattern(
      '*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml',
        vim.fn.getcwd()
    ),
}

lsp_config.clangd.setup {
    cmd = {'clangd', '--background-index', '--compile-commands-dir', 'build/'},
    filetypes = {'c', 'cpp', 'objc', 'objcpp'},
    root_dir = root_pattern(
      'CMakeLists.txt', 'compile_flags.txt', '.git', vim.fn.getcwd()
    ),
}

lsp_config.svelte.setup {}

lsp_config.jsonls.setup {
    cmd = {'vscode-json-languageserver', '--stdio'},
    filetypes = {'json', 'jsonc'},
    init_options = {provideFormatter = true},
    root_dir = root_pattern('.git', vim.fn.getcwd()),
}

lsp_config.html.setup {}

lsp_config.yamlls.setup {}

lsp_config.bashls.setup {filetypes = {'bash', 'sh', 'zsh'}}

local on_publish_cfg = {
    underline = true,
    virtual_text = true,
    update_in_insert = false,
}

lsp.handlers['textDocument/publishDiagnostics'] =
  lsp.with(lsp.diagnostic.on_publish_diagnostics, on_publish_cfg)

local stock_formatting = lsp.handlers['textDocument/formatting']
-- Handle `formatting` error and try to format with 'formatprg'
-- { err, method, result, client_id, bufnr, config }
local function on_formatting(err, ...)
    -- Doesn't work with typescript but does with haskell
    -- if err == nil and (res == nil or #res > 0) then
    if err == nil then
        stock_formatting(err, ...)
    else
        print('Error formatting via LSP, falling back to \'formatprg\'.')
        utils.format_formatprg()
    end
end

lsp.handlers['textDocument/formatting'] = on_formatting
-- TODO: implement '$/progress'
-- handlers['$/progress'] = function(...) dump(...) end
