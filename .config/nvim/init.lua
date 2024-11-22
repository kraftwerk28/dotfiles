local min_version = "nvim-0.8"
if vim.fn.has(min_version) == 0 then
  print("At least " .. min_version .. " is required for this config.")
  -- return
end

-- Define some globals
function autocmd(event, opts)
  return vim.api.nvim_create_autocmd(event, opts or {})
end
function augroup(name, opts)
  return vim.api.nvim_create_augroup(name, opts or {})
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

-- Load options
vim.cmd("runtime opts.vim")

require("kraftwerk28.plugins")
require("kraftwerk28.map")
require("kraftwerk28.autocommand")
require("kraftwerk28.lsp")
require("kraftwerk28.tabline")
-- load("kraftwerk28.statusline")
require("kraftwerk28.filetype")
-- load("kraftwerk28.notify")
require("kraftwerk28.linenumber")
-- load("kraftwerk28.netrw")
-- require("kraftwerk28.manpage_redraw")
