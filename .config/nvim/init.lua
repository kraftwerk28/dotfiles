local min_version = "nvim-0.8"
if vim.fn.has(min_version) == 0 then
  vim.notify(
    string.format("This config supports at least %s.", min_version),
    vim.log.levels.WARN
  )
end

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- vim.g.borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
-- vim.g.borderchars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
vim.g.sql_type_default = "pgsql"

-- Useful Lua globals used in rest of configuration
_G.autocmd = function(event, opts)
  return vim.api.nvim_create_autocmd(event, opts or {})
end
_G.augroup = function(name, opts)
  return vim.api.nvim_create_augroup(name, opts or {})
end

local sev = vim.diagnostic.severity
vim.diagnostic.config {
  virtual_text = true,
  -- virtual_lines = true,
  signs = {
    text = {
      [sev.ERROR] = "",
      [sev.WARN] = "",
      [sev.INFO] = "",
      [sev.HINT] = "",
    },
  },
}

-- Load options
vim.cmd.runtime "opts.vim"

local function lmap_esc(s)
  return vim.fn.escape(s, [[;,"|]])
end

local function lmap_control(lhs, rhs)
  for i = 1, vim.fn.strcharlen(lhs) do
    local map_cyr = vim.fn.strcharpart(lhs, i - 1, 1)
    local map_lat = vim.fn.strcharpart(rhs, i - 1, 1)
    vim.keymap.set("n", "<C-" .. map_cyr .. ">", "<C-" .. map_lat .. ">")
  end
end

local langmap_config = {
  {
    [[йцукенгшщзфівапролдячсмить]],
    [[qwertyuiopasdfghjklzxcvbnm]],
  },
  {
    [[ЙЦУКЕНГШЩЗФІВАПРОЛДЯЧСМИТЬ]],
    [[QWERTYUIOPASDFGHJKLZXCVBNM]],
  },
  {
    [[хїґжєбю]],
    [[[]\;',.]],
  },
  {
    [[ХЇҐЖЄБЮ]],
    [[{}|:"<>]],
  },
}

vim.go.langmap = vim
  .iter(langmap_config)
  :map(function(pair)
    return lmap_esc(pair[1]) .. ";" .. lmap_esc(pair[2])
  end)
  :join(",")

lmap_control(unpack(langmap_config[1]))
lmap_control(unpack(langmap_config[3]))

require "kraftwerk28.plugins"
require "kraftwerk28.map"
require "kraftwerk28.autocommand"
require "kraftwerk28.lsp"
require "kraftwerk28.tabline"
require "kraftwerk28.filetype"
require "kraftwerk28.linenumber"
