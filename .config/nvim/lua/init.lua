local M = {}

local load_plugins = require 'plugins'
local utils = require 'utils'
local highlight = require 'vim.highlight'

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

local function setup_telescope()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'

  local cfg = {
    sorting_strategy = 'ascending',
    prompt_prefix = utils.u 'f002',
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

function M.format_code()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) or vim.bo.filetype == 'haskell' then
    M.format_formatprg()
  else
    vim.lsp.buf.formatting()
  end
end

function M.setup()
  utils.pcall(load_plugins)
  utils.pcall(require 'cfg.treesitter')
  utils.pcall(require 'cfg.lspconfig')
  utils.pcall(setup_telescope)
end

function M.setup_later() utils.pcall(require'translator'.setup) end

function M.yank_highlight() highlight.on_yank {timeout = 1000} end

return M
