local M = {}

local utils = require("config.utils")
local highlight = require("vim.highlight")
local load = utils.load
local fn = vim.fn

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}

-- require('lsp_handlers').patch_lsp_handlers()

load("config.theme")
load("config.mappings")
load("config.opts")
load("plugins")
load("config.tabline")
load("config.statusline")
load("config.filetypes")
-- load("config.experiments")

-- if fn.has("unix") == 1 then
--   -- Clicking any link pointing to neovim or vim docs site
--   -- will open :help split in existing neovim session, if any
--   -- (required corresponding .desktop file which replaces browser
--   pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
-- end

function M.format_code()
  vim.lsp.buf.formatting()
end

function M.save_session()
  vim.cmd("mksession")
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

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

function M.show_line_diagnostics()
  vim.diagnostic.open_float {
    border = vim.g.floatwin_border,
  }
end

return M
