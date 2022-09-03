local api, fn = vim.api, vim.fn

require("kraftwerk28.globals")

local utils = require("kraftwerk28.utils")
local load = utils.load

local min_version = "nvim-0.8"
if fn.has(min_version) == 0 then
  print("At least " .. min_version .. " is required for this config.")
  return
end

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- stylua: ignore start
-- vim.g.borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
vim.g.borderchars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
-- stylua: ignore end
vim.g.diagnostic_signs = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = " ",
}
vim.g.sql_type_default = "pgsql"

pcall(vim.cmd, "source .nvimrc")

vim.cmd("runtime opts.vim")

local ok, err = pcall(function()
  -- require("github-theme").setup({
  --   theme_style = "dark_default",
  --   -- function_style = "italic",
  --   -- sidebars = { "qf", "vista_kind", "terminal", "packer" },
  --   colors = { hint = "orange", error = "#ff0000" },
  --   hide_inactive_statusline = false,
  -- })
  require("onedark").setup({
    style = "warmer",
    ending_tildes = true,
  })

  -- vim.cmd("colorscheme github_dark_default")
  -- vim.cmd("colorscheme base16-gruvbox-light-medium")
  -- vim.cmd("colorscheme kanagawa")
  vim.cmd("colorscheme onedark")
end)

if not ok then
  print(err)
end

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

load("kraftwerk28.map")
load("kraftwerk28.lsp")
load("kraftwerk28.tabline")
load("kraftwerk28.statusline")
load("kraftwerk28.filetype")
load("kraftwerk28.plugins")

load("kraftwerk28.netrw")
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

au("TextYankPost", {
  callback = function()
    local highlight = require("vim.highlight")
    if highlight then
      highlight.on_yank({ timeout = 1000 })
    end
  end,
})

au("FileType", {
  pattern = { "help", "qf", "fugitive", "git", "fugitiveblame" },
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>:bdelete<CR>", {
      buffer = true,
      silent = true,
    })
  end,
  group = api.nvim_create_augroup("aux_win_close", {}),
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

local number_augroup = aug("number")
au({ "BufEnter", "WinEnter", "FocusGained" }, {
  callback = set_nu(true),
  group = number_augroup,
})

au({ "BufLeave", "WinLeave", "FocusLost" }, {
  callback = set_nu(false),
  group = number_augroup,
})

-- set 'makeprg' for some projects
if fn.glob("meson.build") ~= "" then
  o.makeprg = "meson compile -C build"
elseif fn.glob("go.mod") ~= "" then
  o.makeprg = "go build"
end

-- Restore cursor position
au("BufReadPost", {
  callback = function()
    local pos = fn.line([['"]])
    if pos > 0 and pos <= fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

au("BufWinEnter", {
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd("wincmd L | 82wincmd |")
      -- elseif vim.bo.filetype == "man" then
      --   TODO:
      --   local wins = vim.tbl_filter(
      --     function(w)
      --       local b = api.nvim_win_get_buf(w)
      --       local ft = api.nvim_buf_get_option(b, "filetype")
      --       print(b, ft)
      --       return ft ~= "" and ft ~= "man"
      --     end,
      --     api.nvim_tabpage_list_wins(0)
      --   )
      --   print(vim.inspect(wins))
      --   if #wins == 0 then
      --     -- print("should go to the right")
      --     vim.cmd("wincmd L | 82wincmd |")
      --   end
    end
  end,
})

au("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

au("FocusGained", {
  callback = function()
    fn.system("pwd > /tmp/last_pwd")
  end,
})
