local M = {}

local utils = require('utils')
local highlight = require('vim.highlight')
utils.load('opts')

-- :Neoformat will be always ran in these filetypes
vim.g.force_neoformat_filetypes = {
  'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'lua',
}

M.format_code = utils.format_code
M.map = utils.map
utils.nnoremap(
  'dbb',
  function() vim.api.nvim_buf_delete(0, {}) end,
  {silent = true}
)
utils.nnoremap(
  'dbo',
  function() utils.delete_bufs(false) end,
  {silent = true}
)
utils.nnoremap(
  'dba',
  function() utils.delete_bufs(true) end,
  {silent = true}
)

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

vim.g.base16_theme = 'default-dark'

local ok, base16 = pcall(require, 'base16-colorscheme')
if ok then base16.setup(vim.g.base16_theme) end

utils.load('plugins')
utils.load('tabline')
utils.load('statusline')

return M
