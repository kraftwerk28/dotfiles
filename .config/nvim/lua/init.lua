local M = {}

M.lightline = require 'lightline_setup'
M.telescope = require 'telescope.builtin'

local function get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

local function debounce(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
    local args = {...}

    timer_id = vim.fn.timer_start(timeout, function()
      func(args)
      timer_id = nil
    end)
  end
end

local function throttle(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id == nil then
      func {...}
      timer_id = vim.fn.timer_start(timeout, function() timer_id = nil end)
    end
  end
end

local function lsp_diagnostics_helper()
  local debounced = debounce(vim.lsp.diagnostic.show_line_diagnostics, 300)
  local cursorpos = get_cursor_pos()
  return function()
    local new_cursor = get_cursor_pos()
    if (new_cursor[1] ~= 1 and new_cursor[2] ~= 1) and
        (new_cursor[1] ~= cursorpos[1] or new_cursor[2] ~= cursorpos[2]) then
      cursorpos = new_cursor
      debounced()
    end
  end
end

local function format_formatprg()
  local opt_exists, formatprg = pcall(function() return vim.bo.formatprg end)
  if opt_exists and #formatprg > 0 then
    local view = vim.fn.winsaveview()
    vim.api.nvim_command('normal gggqG')
    vim.fn.winrestview(view)
    print('Formatted using \'formatprg\': `' .. formatprg .. '`')
    return true
  else
    return false
  end
end

M.show_lsp_diagnostics = lsp_diagnostics_helper()

local function setup_treesitter()
  local ts = require 'nvim-treesitter.configs'
  local disabled = {
    'dart', 'ocaml', 'java', 'clojure', 'gdscript', 'ocamllex', 'fennel',
    'verilog', 'sparql', 'turtle', 'teal'
  }
  ts.setup {
    ensure_installed = 'maintained',
    highlight = {enable = true, disable = disabled}
    -- indent = { enable = true },
  }
end

local function setup_lsp()
  local lsp = require 'lspconfig'
  local configs = require 'lspconfig/configs'
  -- on_attach is called in init.vim

  local ts_cfg = {
    cmd = {'typescript-language-server', '--stdio'},
    filetypes = {
      'javascript', 'javascriptreact', 'typescript', 'typescriptreact'
    },
    root_dir = lsp.util.root_pattern('package.json', 'tsconfig.json', '.git')
  }

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
      matchDir = '[^\\.].*'
    },
    rope_completion = {enabled = true},
    yapf = {enabled = true}
  }

  local emmet_cfg = {
    cmd = {'emmet-ls', '--stdio'},
    filetypes = {'html', 'css', 'typescriptreact', 'javascriptreact'},
    root_dir = function() return vim.loop.cwd() end,
    settings = {}
  }

  local svelte_cfg = {
    cmd = {'svelteserver', '--stdio'},
    filetypes = {'svelte'},
    root_dir = function() return vim.loop.cwd() end,
    settings = {}
  }

  local lua_cfg = {cmd = {'lua-language-server'}}

  configs.emmet_ls = {default_config = emmet_cfg}
  configs.svelte = {default_config = svelte_cfg}

  lsp.tsserver.setup(ts_cfg)
  lsp.pyls.setup(python_cfg)
  lsp.sumneko_lua.setup(lua_cfg)
  lsp.rust_analyzer.setup {}
  lsp.gopls.setup {}
  lsp.hls.setup {}
  lsp.clangd.setup {}
  lsp.emmet_ls.setup {}
  lsp.svelte.setup {}

  local on_publish_cfg = {
    underline = true,
    virtual_text = true,
    update_in_insert = false
  }
  local on_publish_handler = vim.lsp.with(
                                 vim.lsp.diagnostic.on_publish_diagnostics,
                                 on_publish_cfg)

  local function on_publish_diagnostics(...)
    vim.api.nvim_command('doautocmd User LSPOnDiagnostics')
    on_publish_handler(...)
  end

  local stock_formatting = vim.lsp.handlers['textDocument/formatting']
  -- Handle `formatting` error and try to format with 'formatprg'
  -- { err, method, result, client_id, bufnr, config }
  local function on_formatting(err, method, res, ...)
    -- Doesn't work with typescript but does with haskell
    -- if err == nil and (res == nil or #res > 0) then
    if err == nil then
      stock_formatting(err, method, res, ...)
    else
      print('Error formatting w/ LSP, falling back to \'formatprg\'...')
      format_formatprg()
    end
  end

  vim.lsp.handlers['textDocument/formatting'] = on_formatting
  vim.lsp.handlers['textDocument/publishDiagnostics'] = on_publish_diagnostics
end

local function setup_telescope()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  local previewers = require 'telescope.previewers'

  local cfg = {
    sorting_strategy = 'ascending',
    prompt_prefix = '',
    prompt_position = 'top',
    color_devicons = true,
    scroll_strategy = 'cycle',
    winblend = 20,
    file_previewer = previewers.vim_buffer_cat.new,
    mappings = {
      i = {
        ['<C-K>'] = actions.move_selection_previous,
        ['<C-J>'] = actions.move_selection_next,
        ['<Esc>'] = actions.close
      }
    },
  }

  telescope.setup {defaults = cfg}
end

function M.format_code()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    format_formatprg()
  else
    vim.lsp.buf.formatting()
  end
end

function M.setup()
  setup_treesitter()
  setup_lsp()
  setup_telescope()
end

return M
