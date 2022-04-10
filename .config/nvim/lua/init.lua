local M = {}
local api, fn = vim.api, vim.fn

local utils = require("config.utils")
local load = utils.load

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
vim.g.diagnostic_signs = {
  ERROR = " ", WARN  = " ", INFO  = " ", HINT  = " ",
}

function _G.printf(...)
  return print(string.format(...))
end

-- require('config.lsp_handlers').patch_lsp_handlers()

-- NB: The theme must *not* be set in the packer's `config` function to
-- and load theme immediately instead of lazily
-- require("github-theme").setup {
--   theme_style = "dark_default",
--   hide_inactive_statusline = false,
-- }


load("config.mappings")
-- load("config.opts")
load("config.lsp")
load("config.tabline")
load("config.statusline")
load("config.filetypes")
load("plugins")
-- load("config.experiments")

-- if fn.has("unix") == 1 then
--   -- Clicking any link pointing to neovim or vim docs site
--   -- will open :help split in existing neovim session, if any
--   -- (required corresponding .desktop file which replaces browser
--   pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
-- end

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

api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local highlight = require("vim.highlight")
    if highlight then
      highlight.on_yank { timeout = 1000 }
    end
  end,
})

do
  local no_line_number_ft = {"help", "man", "list", "TelescopePrompt"}
  local f = utils.defglobalfn(function(relative)
    if
      fn.win_gettype() == "popup"
      or vim.tbl_contains(no_line_number_ft, vim.bo.filetype)
    then return end
    vim.wo.number = true
    vim.wo.relativenumber = relative
  end)
  vim.cmd(("autocmd BufEnter,WinEnter,FocusGained * lua %s(true)"):format(f))
  vim.cmd(("autocmd BufLeave,WinLeave,FocusLost * lua %s(false)"):format(f))
end

do
  api.nvim_add_user_command(
    "GoChangeScope",
    function()
      local word = fn.expand("<cword>")
      local fst = word:sub(1, 1)
      if fst:match("[A-Z]") then
        word = fst:lower()..word:sub(2)
      else
        word = fst:upper()..word:sub(2)
      end
      vim.lsp.buf.rename(word)
    end,
    {}
  )
end

return M
