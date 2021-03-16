local utils = require 'utils'
local lsp = require 'lspconfig'
local root_pattern = require'lspconfig.util'.root_pattern
-- on_attach is called in init.vim
local hl = utils.highlight

hl {'LspDiagnosticsUnderlineHint', gui = 'undercurl'}
hl {'LspDiagnosticsUnderlineInformation', gui = 'undercurl'}
hl {'LspDiagnosticsUnderlineWarning', gui = 'undercurl', guisp = 'orange'}
hl {'LspDiagnosticsUnderlineError', gui = 'undercurl', guisp = 'red'}
hl {'LspDiagnosticsDefaultHint', fg = 'yellow'}
hl {'LspDiagnosticsDefaultInformation', fg = 'lightblue'}
hl {'LspDiagnosticsDefaultWarning', fg = 'orange'}
hl {'LspDiagnosticsDefaultError', fg = 'red'}

local u = utils.u
local lsp_signs = {
  LspDiagnosticsSignHint = {text = u 'f0eb', texthl = 'LspDiagnosticsSignHint'},
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

lsp.tsserver.setup {
  root_dir = root_pattern(
    'package.json', 'tsconfig.json', 'jsconfig.json', '.git', vim.fn.getcwd()
  ),
}

lsp.pyls.setup {
  cmd = {'pyls'},
  filetypes = {'python'},
  settings = {
    pyls = {
      plugins = {
        jedi_completion = {enabled = true},
        jedi_hover = {enabled = true},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},
        yapf = {enabled = false},
        pylint = {enabled = false},
        pycodestyle = {enabled = false},
        pydocstyle = {enabled = false},
        mccabe = {enabled = false},
        preload = {enabled = false},
        rope_completion = {enabled = false},
      },
    },
  },
}

lsp.sumneko_lua.setup {
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

lsp.rust_analyzer.setup {}

lsp.gopls.setup {}

lsp.hls.setup {
  settings = {haskell = {formattingProvider = 'brittany'}},
  root_dir = root_pattern(
    '*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml',
      vim.fn.getcwd()
  ),
}

lsp.clangd.setup {
  cmd = {'clangd', '--background-index', '--compile-commands-dir', 'build/'},
  filetypes = {'c', 'cpp', 'objc', 'objcpp'},
  root_dir = root_pattern(
    'CMakeLists.txt', 'compile_flags.txt', '.git', vim.fn.getcwd()
  ),
}

lsp.svelte.setup {}

lsp.jsonls.setup {
  cmd = {'vscode-json-languageserver', '--stdio'},
  filetypes = {'json', 'jsonc'},
  init_options = {provideFormatter = true},
}

lsp.html.setup {}

lsp.yamlls.setup {}

lsp.bashls.setup {filetypes = {'bash', 'sh', 'zsh'}}

local on_publish_cfg = {
  underline = true,
  virtual_text = true,
  update_in_insert = false,
}

local on_publish_handler = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, on_publish_cfg
)

local function on_publish_diagnostics(...)
  vim.api.nvim_command 'doautocmd User LSPOnDiagnostics'
  on_publish_handler(...)
end

local handlers = vim.lsp.handlers

local stock_formatting = handlers['textDocument/formatting']
-- Handle `formatting` error and try to format with 'formatprg'
-- { err, method, result, client_id, bufnr, config }
local function on_formatting(err, ...)
  -- Doesn't work with typescript but does with haskell
  -- if err == nil and (res == nil or #res > 0) then
  if err == nil then
    stock_formatting(err, ...)
  else
    print 'Error formatting w/ LSP, falling back to \'formatprg\'...'
    utils.format_formatprg()
  end
end

handlers['textDocument/formatting'] = on_formatting
handlers['textDocument/publishDiagnostics'] = on_publish_diagnostics
-- handlers['$/progress'] = function(...) dump(...) end
-- TODO: implement '$/progress'
