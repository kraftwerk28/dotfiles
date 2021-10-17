local utils = require("config.utils")

local function delete_bufs(include_current)
  local cur = vim.api.nvim_get_current_buf()
  for _, h in ipairs(vim.api.nvim_list_bufs()) do
    if (h ~= cur or include_current) and vim.api.nvim_buf_is_loaded(h) then
      vim.api.nvim_buf_delete(h, {})
    end
  end
end

utils.nnoremap(
  "dbb",
  function()
    vim.cmd("wincmd v")
    vim.api.nvim_buf_delete(0, {})
  end,
  {silent = true}
)

utils.nnoremap("dbo", function() delete_bufs(false) end, {silent = true})
utils.nnoremap("dba", function() delete_bufs(true) end, {silent = true})
