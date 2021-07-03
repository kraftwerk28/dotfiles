local M = {}

local utils = require("utils")
local highlight = require("vim.highlight")
local load = utils.load

-- Setup theme
do
  vim.g.base16_theme = "default-dark"
  local ok, base16 = pcall(require, "base16-colorscheme")
  if ok then base16.setup(vim.g.base16_theme) end
end

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60

if vim.go.term == "nvim" then
  vim.cmd("packadd neovim-gui-shim")
end

require('lsp_handlers').patch_lsp_handlers()

load("mappings")
load("opts")
load("plugins")
load("tabline")
load("statusline")

if vim.fn.has("unix") == 1 then
  -- Clicking any link pointing to neovim or vim docs site
  -- will open :help split in existing neovim session, if any
  -- (required corresponding .desktop file which replaces browser
  pcall(vim.fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
end

M.format_code = utils.format_code

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

return M
