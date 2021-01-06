local devicons = require('nvim-web-devicons')

local M = {}

function M.filename_label()
  local filename, ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
  if #filename > 0 then
    local icon = devicons.get_icon(filename, ext)
    if not icon then icon = '' end
    return icon .. ' ' .. filename
  else
    return ''
  end
end

local filetype_icon = {dos = '', unix = '', mac = ''}

function M.filetype_label()
  if vim.fn.winwidth(0) > 70 then
    local icon = filetype_icon[vim.bo.fileformat]
    if not icon then icon = '' end
    return icon .. ' ' .. vim.bo.filetype
  else
    return ''
  end
end

local function lsp_warns()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ''
  else
    local n = vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Warning')
    if n > 0 then
      return n
    else
      return ''
    end
  end
end

local function lsp_errors()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ''
  else
    local n = vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Error')
    if n > 0 then
      return n
    else
      return ''
    end
  end
end

return M
