local utils = require 'utils'

return function()
  local lsp = require 'lspconfig'
  -- on_attach is called in init.vim

  local python_cfg = {
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

  local emmet_cfg = {
    cmd = {'emmet-ls', '--stdio'},
    filetypes = {'html', 'css', 'typescriptreact', 'javascriptreact'},
    root_dir = function() return vim.loop.cwd() end,
    settings = {},
  }

  local lua_cfg = {
    cmd = {
      'lua-language-server',
      '-E',
      '/usr/share/lua-language-server/main.lua',
      '--logpath',
      vim.lsp.get_log_path():match('(.*[/\\])'),
    },
    settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
        diagnostics = {globals = {'vim'}},
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    },
  }

  local json_cfg = {
    cmd = {'vscode-json-languageserver', '--stdio'},
    filetypes = {'json', 'jsonc'},
    init_options = {provideFormatter = true},
  }

  lsp.tsserver.setup {}
  lsp.pyls.setup(python_cfg)
  lsp.sumneko_lua.setup(lua_cfg)
  lsp.rust_analyzer.setup {}
  lsp.gopls.setup {}
  lsp.hls.setup {}
  lsp.clangd.setup {}
  lsp.svelte.setup {}
  lsp.jsonls.setup(json_cfg)
  lsp.html.setup {}

  local on_publish_cfg = {
    underline = true,
    virtual_text = true,
    update_in_insert = false,
  }

  local on_publish_handler = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, on_publish_cfg)

  local function on_publish_diagnostics(...)
    vim.api.nvim_command('doautocmd User LSPOnDiagnostics')
    on_publish_handler(...)
  end

  local stock_formatting = vim.lsp.handlers['textDocument/formatting']
  -- Handle `formatting` error and try to format with 'formatprg'
  -- { err, method, result, client_id, bufnr, config }
  local function on_formatting(err, ...)
    -- Doesn't work with typescript but does with haskell
    -- if err == nil and (res == nil or #res > 0) then
    if err == nil then
      stock_formatting(err, ...)
    else
      print('Error formatting w/ LSP, falling back to \'formatprg\'...')
      utils.format_formatprg()
    end
  end

  vim.lsp.handlers['textDocument/formatting'] = on_formatting
  vim.lsp.handlers['textDocument/publishDiagnostics'] = on_publish_diagnostics
end
