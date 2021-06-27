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

vim.g.base16_theme = "default-dark"

local ok, base16 = pcall(require, 'base16-colorscheme')
if ok then base16.setup(vim.g.base16_theme) end

do
  vim.g.neovide_fullscreen = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_fullscreen = true
  vim.env.NeovideMultiGrid = 1
end

require('lsp_handlers').patch_lsp_handlers()
utils.load('plugins')
utils.load('tabline')
utils.load('statusline')

if vim.fn.has("unix") == 1 then
  -- Listen for :help call from .desktop python script
  pcall(vim.fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
end

-- do
--   local curl = require('plenary.curl')
--   curl.get{
--     url = "https://api.github.com/search/repositories",
--     query = {
--       q = "vim-surround",
--       per_page = 1,
--     },
--     raw = {
--       '-H',
--       "Authorization: token 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",
--     },
--     callback = vim.schedule_wrap(function(res)
--       local norm_headers = {}
--       for _, h in ipairs(res.headers) do
--         local name, value = h:match("(%w+):%s*(%w+)")
--         if name ~= nil then
--           norm_headers[name] = value
--         end
--       end
--       dump(norm_headers)
--       dump(vim.fn.json_decode(res.body))
--     end),
--   }
-- end

do
end

return M
