local M = {}

local load_plugins = require 'plugins'
local utils = require 'utils'
local highlight = require 'vim.highlight'

function _G.dump(...)
  local args = {...}
  if #args == 1 then
    print(vim.inspect(args[1]))
  else
    print(vim.inspect(args))
  end
end

M.show_lsp_diagnostics = (function()
  local debounced =
    utils.debounce(vim.lsp.diagnostic.show_line_diagnostics, 300)
  local cursorpos = utils.get_cursor_pos()
  return function()
    local new_cursor = utils.get_cursor_pos()
    if (new_cursor[1] ~= 1 and new_cursor[2] ~= 1) and
      (new_cursor[1] ~= cursorpos[1] or new_cursor[2] ~= cursorpos[2]) then
      cursorpos = new_cursor
      debounced()
    end
  end
end)()

local function setup_treesitter()
  local ts_configs = require'nvim-treesitter.parsers'.get_parser_configs()

  ts_configs.elixir = {
    install_info = {
      url = '~/projects/treesitter/tree-sitter-elixir',
      files = {'src/parser.c'},
    },
    filetype = 'elixir',
  }

  local disabled = {
    'dart',
    'ocaml',
    'java',
    'clojure',
    'gdscript',
    'ocamllex',
    'fennel',
    'verilog',
    'sparql',
    'turtle',
    'teal',
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
end

local function setup_lsp()
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

local function setup_telescope()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'

  local cfg = {
    sorting_strategy = 'ascending',
    prompt_prefix = '',
    prompt_position = 'top',
    color_devicons = true,
    scroll_strategy = 'cycle',
    mappings = {
      i = {
        ['<C-K>'] = actions.move_selection_previous,
        ['<C-J>'] = actions.move_selection_next,
        ['<Esc>'] = actions.close,
      },
    },
  }

  telescope.setup {defaults = cfg}
end

local function setup_bufferline()
  require'bufferline'.setup {
    options = {always_show_bufferline = false, show_buffer_close_icons = false},
    highlights = {
      buffer_selected = {gui = 'bold'},
      background = {guifg = 'gray'},
    },
  }
end

function M.format_code()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) or vim.bo.filetype == 'haskell' then
    utils.format_formatprg()
  else
    vim.lsp.buf.formatting()
  end
end

function M.setup()
  load_plugins()
  setup_treesitter()
  setup_lsp()
  setup_telescope()
end

function M.yank_highlight() highlight.on_yank {timeout = 1000} end

return M
