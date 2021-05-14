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
    -- guisp = 'Orange',
}
-- highlight {'LspDiagnosticsUnderlineError', gui = 'undercurl', guisp = 'Red'}
highlight {'LspDiagnosticsUnderlineError', gui = 'undercurl'}

-- highlight {'LspDiagnosticsDefaultHint', fg = 'Yellow'}
-- highlight {'LspDiagnosticsDefaultInformation', fg = 'LightBlue'}
highlight {'LspDiagnosticsDefaultWarning', fg = 'Orange'}
-- highlight {'LspDiagnosticsDefaultError', fg = 'Red'}

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

-- lsp_config.flow.setup {
--     cmd = {'flow', 'lsp'},
--     filetypes = {'javascript', 'javascriptreact'},
--     root_dir = root_pattern('.flowconfig'),
-- }

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

local clangdcmd = {'clangd', '--background-index'}
if vim.fn.empty(vim.fn.glob('compile_commands.json')) > 0 then
    vim.tbl_extend('force', clangdcmd, {'--compile-commands-dir', 'build'})
end

lsp_config.clangd.setup {
    cmd = clangdcmd,
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

local function setup_diagnostics()
    local method = 'textDocument/publishDiagnostics'
    local on_publish_cfg = {
        underline = true,
        virtual_text = true,
        update_in_insert = false,
    }
    local diagnostics_handler = lsp.with(
      lsp.diagnostic.on_publish_diagnostics, on_publish_cfg
    )
    lsp.handlers[method] = diagnostics_handler
    return
    -- populate quickfix list with diagnostics
    -- lsp.handlers[method] = function(...)
    --     diagnostics_handler(...)
    --     local err, method, result, client_id = ...
    --     if result and result.diagnostics then
    --         local item_list = {}
    --         for _, v in ipairs(result.diagnostics) do
    --             table.insert(
    --               item_list, {
    --                   filename = result.uri,
    --                   lnum = v.range.start.line + 1,
    --                   col = v.range.start.character + 1,
    --                   text = v.message,
    --               }
    --             )
    --         end
    --         local old_items = vim.fn.getqflist()
    --         for _, old_item in ipairs(old_items) do
    --             local bufnr = vim.uri_to_bufnr(result.uri)
    --             if vim.uri_from_bufnr(old_item.bufnr) ~= result.uri then
    --                 table.insert(item_list, old_item)
    --             end
    --         end
    --         vim.fn.setqflist({}, ' ', {title = 'LSP', items = item_list})
    --     end
    -- end
end

local function setup_formatting()
    local method = 'textDocument/formatting'
    local defaut_handler = lsp.handlers[method]
    lsp.handlers[method] = function(...)
        local err = ...
        if err == nil then
            defaut_handler(...)
        else
            vim.cmd('Neoformat')
        end
    end
end

setup_diagnostics()
setup_formatting()
-- TODO: implement '$/progress'
-- handlers['$/progress'] = function(...) dump(...) end
