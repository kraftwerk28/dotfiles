local min_version = "nvim-0.8"
if vim.fn.has(min_version) == 0 then
  vim.notify(
    ("This config supports at least %s."):format(min_version),
    vim.log.levels.WARN
  )
end

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- vim.g.borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
-- vim.g.borderchars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
vim.g.diagnostic_signs = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = " ",
}
vim.g.sql_type_default = "pgsql"

-- Define some globals
_G.autocmd = function(event, opts)
  return vim.api.nvim_create_autocmd(event, opts or {})
end
_G.augroup = function(name, opts)
  return vim.api.nvim_create_augroup(name, opts or {})
end
_G.set = vim.opt
_G.setl = vim.opt_local
_G.setlocal = vim.opt_local
_G.setg = vim.opt_global
_G.setglobal = vim.opt_global

-- Load options
vim.cmd.runtime "opts.vim"

require "kraftwerk28.plugins"
require "kraftwerk28.map"
require "kraftwerk28.autocommand"
require "kraftwerk28.lsp"
require "kraftwerk28.tabline"
require "kraftwerk28.filetype"
require "kraftwerk28.linenumber"
