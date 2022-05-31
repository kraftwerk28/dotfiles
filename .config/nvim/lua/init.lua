local M = {}
local api, fn = vim.api, vim.fn

local utils = require("config.utils")
local load = utils.load

_G.A = setmetatable({}, {
  __index = function(_, k)
    return vim.api["nvim_" .. k]
  end,
})

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- stylua: ignore start
-- vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
vim.g.floatwin_border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
-- stylua: ignore end
vim.g.diagnostic_signs = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = " ",
}
vim.g.sql_type_default = "sqlanywhere"

vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme base16-gruvbox-light-medium")
-- vim.cmd("colorscheme base16-gruvbox-dark-medium")

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

local function rtp_searchpath(path)
  local p = package.searchpath(
    path,

    table.concat(
      vim.tbl_flatten(vim.tbl_map(function(p)
        return { p .. "/lua/?.lua", p .. "/lua/?/init.lua" }
      end, api.nvim_list_runtime_paths())),
      ";"
    )

    -- table.concat(
    --   vim.tbl_flatten(
    --     vim.tbl_map(function(p)
    --       return { p .. "/lua/?.lua", p .. "/lua/?/init.lua" }
    --     end, vim.split(vim.o.runtimepath, ",")),
    --     vim.split(vim.o.runtimepath, ";")
    --   ),
    --   ";"
    -- )
  )
  return p
end

function _G.reload_config()
  -- TODO:
  for k in pairs(package.loaded) do
    local spath = rtp_searchpath(k)
    if
      spath
      and not spath:find("packer")
      and (
        spath:find(fn.stdpath("data"), 1, true)
        or spath:find(fn.stdpath("config"), 1, true)
      )
    then
      print("Invalidating module: " .. k)
      package.loaded[k] = nil
    end
  end
  vim.cmd("runtime init.vim")
  require("packer").compile()
end

load("config.mappings")
load("config.lsp")
load("config.tabline")
load("config.statusline")
load("config.filetypes")
load("plugins")

-- if fn.has("unix") == 1 then
--   -- Clicking any link pointing to neovim or vim docs site
--   -- will open :help split in existing neovim session, if any
--   -- (required corresponding .desktop file which replaces browser
--   pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
-- end

api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local highlight = require("vim.highlight")
    if highlight then
      highlight.on_yank({ timeout = 1000 })
    end
  end,
})

do
  local no_line_number_ft = { "help", "man", "list", "TelescopePrompt", "git" }
  local function set_nu(relative)
    return function()
      if fn.win_gettype() == "popup" then
        return
      end
      if vim.tbl_contains(no_line_number_ft, vim.bo.filetype) then
        return
      end
      vim.wo.number = true
      vim.wo.relativenumber = relative
    end
  end
  vim.api.nvim_create_autocmd("BufEnter,WinEnter,FocusGained", {
    callback = set_nu(true),
  })
  vim.api.nvim_create_autocmd("BufLeave,WinLeave,FocusLost", {
    callback = set_nu(false),
  })
end

-- set 'makeprg' for some projects
if vim.fn.glob("meson.build") ~= "" then
  vim.o.makeprg = "meson compile -C build"
elseif vim.fn.glob("go.mod") ~= "" then
  vim.o.makeprg = "go build"
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local pos = vim.fn.line([['"]])
    if pos > 0 and pos <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd("wincmd L | 82wincmd |")
    elseif vim.bo.filetype == "man" then
      -- TODO:
      -- local wins = vim.tbl_filter(
      --   function(w)
      --     local b = vim.api.nvim_win_get_buf(w)
      --     local ft = vim.api.nvim_buf_get_option(b, "filetype")
      --     print(b, ft)
      --     return ft ~= "" and ft ~= "man"
      --   end,
      --   vim.api.nvim_tabpage_list_wins(0)
      -- )
      -- print(vim.inspect(wins))
      -- if #wins == 0 then
      --   -- print("should go to the right")
      --   vim.cmd("wincmd L | 82wincmd |")
      -- end
    end
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.fn.system("pwd > /tmp/last_pwd")
  end,
})

return M
