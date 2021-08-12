local M = {}

local utils = require("utils")
local highlight = require("vim.highlight")
local load = utils.load
local fn = vim.fn

vim.g.base16_theme = "default-dark"
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

if fn.has("unix") == 1 then
  -- Clicking any link pointing to neovim or vim docs site
  -- will open :help split in existing neovim session, if any
  -- (required corresponding .desktop file which replaces browser
  pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
end

M.format_code = utils.format_code

function M.save_session()
  vim.cmd("mks")
end

function M.restore_session()
  if fn.filereadable("Session.vim") == 0 then
    return
  end
  vim.cmd("source Session.vim")
  if fn.bufexists(1) == 1 then
    for i = 1, fn.bufnr("$") do
      if fn.bufwinnr(i) == -1 then
        vim.cmd("sbuffer "..i)
      end
    end
  end
end

function M.show_line_diagnostics()
  vim.lsp.diagnostic.show_line_diagnostics({ border = vim.g.floatwin_border })
end

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

-- local tm = vim.loop.new_timer()
-- local count = 0
-- tm:start(1000, 1000, vim.schedule_wrap(function()
--   count = count + 1
--   dump{count, fn.getpos("'<"), fn.getpos("'>")}
-- end))

return M
