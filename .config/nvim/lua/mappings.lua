local utils = require("utils")

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
