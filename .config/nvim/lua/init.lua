local M = {}

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

function M.format_code()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) or vim.bo.filetype == 'haskell' then
    utils.format_formatprg()
  else
    vim.lsp.buf.formatting()
  end
end

function M.yank_highlight() highlight.on_yank {timeout = 1000} end

function M.attach_completion()
  local ok, completion = pcall(require, 'completion')
  if ok then completion.on_attach() end
end

function M.run_prettier()
  if vim.fn.executable('prettier') == 0 then return end
  local ft = vim.bo.filetype
  local parser
  if ft == 'typescript' or ft == 'typescriptreact' then
    parser = 'typescript'
  elseif ft == 'javascript' or ft == 'javascriptreact' then
    parser = 'babel'
  end
  local old_formatprg = vim.bo.formatprg
  vim.bo.formatprg = 'prettier --parser ' .. parser
  utils.format_formatprg()
  vim.bo.formatprg = old_formatprg
end

function M.restart_lsp()
  local clients = vim.lsp.get_active_clients()
  if not vim.tbl_isempty(clients) then
    vim.lsp.stop_client(clients)
    vim.defer_fn(function() vim.cmd('edit') end, 100)
  end
end

function M.setup() utils.load 'plugins' end

function M.setup_later() utils.load 'statusline' end

return M
