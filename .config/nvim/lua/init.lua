local M = {}

local utils = require("utils")
local highlight = require("vim.highlight")
local load = utils.load

M.format_code = utils.format_code

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

do
  vim.g.base16_theme = "default-dark"
  local ok, base16 = pcall(require, "base16-colorscheme")
  if ok then base16.setup(vim.g.base16_theme) end
end

-- :Neoformat will be always ran in these filetypes
-- If LSP isn't capable to do nice formatting, I place that filetype below
vim.g.force_neoformat_filetypes = {
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
  "lua",
  "python",
}
vim.g.neovide_refresh_rate = 60

require('lsp_handlers').patch_lsp_handlers()
load("mappings")
load("opts")
load("plugins")
load("tabline")
load("statusline")

if vim.fn.has("unix") == 1 then
  -- Listen for :help call from .desktop python script
  pcall(vim.fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
end

return M
