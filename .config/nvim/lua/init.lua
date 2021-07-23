local M = {}

local utils = require("utils")
local highlight = require("vim.highlight")
local load = utils.load

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}

require('lsp_handlers').patch_lsp_handlers()

load("theme")
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

function M.show_line_diagnostics()
  vim.lsp.diagnostic.show_line_diagnostics({ border = vim.g.floatwin_border })
end

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

return M
