-- local utils = require("config.utils")
-- local api = vim.api

-- utils.nnoremap(
--   "dbb",
--   function()
--     vim.cmd("wincmd v")
--     api.nvim_buf_delete(0, {})
--   end,
--   {silent = true}
-- )

-- utils.nnoremap(
--   "dbo",
--   function()
--     local cur = api.nvim_get_current_buf()
--     vim.cmd("wall")
--     for _, h in ipairs(api.nvim_list_bufs()) do
--       if h ~= cur and api.nvim_buf_is_loaded(h) then
--         api.nvim_buf_delete(h)
--       end
--     end
--   end,
--   { silent = true }
-- )

-- utils.nnoremap(
--   "dba",
--   function()
--     local cur = api.nvim_get_current_buf()
--     vim.cmd("wall")
--     for _, h in ipairs(api.nvim_list_bufs()) do
--       api.nvim_buf_delete(h)
--     end
--   end,
--   { silent = true }
-- )
