local M = {}
local api, fn = vim.api, vim.fn

local utils = require("config.utils")
local load = utils.load

local min_version = "nvim-0.8"
if fn.has(min_version) == 0 then
  print("At least " .. min_version .. " is required for this config.")
  return
end

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

local colorscheme = "kanagawa"
-- local colorscheme = "base16-gruvbox-light-medium"
local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
  print(err)
end

-- NB: The theme must *not* be set in the packer's `config` function to
-- and load theme immediately instead of lazily
-- require("github-theme").setup {
--   theme_style = "dark_default",
--   hide_inactive_statusline = false,
-- }

_G.reload_config = function()
  local rtp_lua_path = table.concat(
    vim.tbl_flatten(vim.tbl_map(function(p)
      return { p .. "/lua/?.lua", p .. "/lua/?/init.lua" }
    end, api.nvim_list_runtime_paths())),
    ";"
  )

  for k in pairs(package.loaded) do
    local spath = package.searchpath(k, rtp_lua_path)
    if spath and spath:find(fn.stdpath("config"), 1, true) then
      print(("Reloading %s (%s)"):format(k, spath))
      package.loaded[k] = nil
    end
  end

  vim.cmd("runtime! init.vim")
  vim.cmd("runtime! plugin/**/*.{vim,lua}")
  api.nvim_exec_autocmds({ "FileType" }, {})
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

local qclose_group = api.nvim_create_augroup("aux_win_close", {})
api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "fugitive", "git", "fugitiveblame" },
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>:bdelete<CR>", {
      buffer = true,
      silent = true,
    })
  end,
  group = qclose_group,
})

local no_line_number_ft = { "help", "man", "list", "TelescopePrompt" }
local function set_nu(relative)
  return function()
    if fn.win_gettype() == "popup" then
      return
    end
    if vim.tbl_contains(no_line_number_ft, vim.bo.filetype) then
      return
    end
    vim.o.number = true
    vim.o.relativenumber = relative
  end
end
api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
  callback = set_nu(true),
})
api.nvim_create_autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  callback = set_nu(false),
})

-- set 'makeprg' for some projects
if fn.glob("meson.build") ~= "" then
  vim.o.makeprg = "meson compile -C build"
elseif fn.glob("go.mod") ~= "" then
  vim.o.makeprg = "go build"
end

api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local pos = fn.line([['"]])
    if pos > 0 and pos <= fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd("wincmd L | 82wincmd |")
    elseif vim.bo.filetype == "man" then
      -- TODO:
      -- local wins = vim.tbl_filter(
      --   function(w)
      --     local b = api.nvim_win_get_buf(w)
      --     local ft = api.nvim_buf_get_option(b, "filetype")
      --     print(b, ft)
      --     return ft ~= "" and ft ~= "man"
      --   end,
      --   api.nvim_tabpage_list_wins(0)
      -- )
      -- print(vim.inspect(wins))
      -- if #wins == 0 then
      --   -- print("should go to the right")
      --   vim.cmd("wincmd L | 82wincmd |")
      -- end
    end
  end,
})

api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

api.nvim_create_autocmd("FocusGained", {
  callback = function()
    fn.system("pwd > /tmp/last_pwd")
  end,
})

return M
