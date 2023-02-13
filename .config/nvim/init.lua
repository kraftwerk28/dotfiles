require("kraftwerk28.globals")

local min_version = "nvim-0.8"
if vim.fn.has(min_version) == 0 then
  print("At least " .. min_version .. " is required for this config.")
  return
end

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- vim.g.borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
vim.g.borderchars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
vim.g.diagnostic_signs = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = " ",
}
vim.g.sql_type_default = "pgsql"

-- Load options
vim.cmd.runtime("opts.vim")

_G.reload_config = function()
  local rtp_lua_path = table.concat(
    vim.tbl_flatten(vim.tbl_map(function(p)
      return { p .. "/lua/?.lua", p .. "/lua/?/init.lua" }
    end, vim.api.nvim_list_runtime_paths())),
    ";"
  )

  for k in pairs(package.loaded) do
    local spath = package.searchpath(k, rtp_lua_path)
    if spath and spath:find(vim.fn.stdpath("config"), 1, true) then
      print(("Reloading %s (%s)"):format(k, spath))
      package.loaded[k] = nil
    end
  end

  vim.cmd("runtime! init.vim")
  vim.cmd("runtime! plugin/**/*.{vim,lua}")
  vim.api.nvim_exec_autocmds({ "FileType" }, {})
end

local function load(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    print(err)
  end
  -- if not ok then
  --   vim.api.nvim_err_write(err)
  -- end
end

load("kraftwerk28.theme")
load("kraftwerk28.map")
load("kraftwerk28.lsp")
load("kraftwerk28.lsp.servers")
load("kraftwerk28.tabline")
load("kraftwerk28.statusline")
load("kraftwerk28.filetype")
load("kraftwerk28.notify")
load("kraftwerk28.linenumber")
load("kraftwerk28.plugins")
-- load("kraftwerk28.netrw")

autocmd("TextYankPost", {
  callback = function()
    require("vim.highlight").on_yank({ timeout = 1000 })
  end,
})

-- set 'makeprg' for some projects
if vim.fn.glob("meson.build") ~= "" then
  vim.o.makeprg = "meson compile -C build"
elseif vim.fn.glob("go.mod") ~= "" then
  vim.o.makeprg = "go build"
end

-- Restore cursor position
autocmd("BufReadPost", {
  callback = function()
    local pos = vim.fn.line([['"]])
    if pos > 0 and pos <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

autocmd("BufWinEnter", {
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd("wincmd L | 82wincmd |")
    end
  end,
})

autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

autocmd("FocusGained", {
  callback = function()
    vim.fn.writefile({ vim.fn.getcwd() }, "/tmp/last_pwd")
  end,
})

-- Redraw manpage for the current window width
-- do
--   local resize_timer
--   local resize_winids
--
--   local function redraw_manpages()
--     local current_winid = vim.api.nvim_get_current_win()
--     if
--       resize_winids == nil
--       or not vim.api.nvim_win_is_valid(current_winid)
--       or not vim.tbl_contains(resize_winids, current_winid)
--     then
--       return
--     end
--     local bufid = vim.api.nvim_win_get_buf(current_winid)
--     local ft = vim.api.nvim_buf_get_option(bufid, "filetype")
--     if ft == "man" then
--       local bufname = vim.api.nvim_buf_get_name(bufid)
--       local winview = vim.fn.winsaveview()
--       require("man").read_page(vim.fn.matchstr(bufname, "man://\\zs.*"))
--       vim.fn.winrestview(winview)
--     end
--     resize_timer = nil
--     resize_winids = nil
--   end
--
--   autocmd("WinResized", {
--     callback = function()
--       if resize_timer ~= nil then
--         resize_timer:stop()
--       end
--       resize_winids = vim.v.event.windows
--       resize_timer = vim.defer_fn(redraw_manpages, 1000)
--     end,
--   })
-- end

-- params.match:
-- {
--   params = {
--     buf = 3,
--     event = "BufReadCmd",
--     file = "man://sway(5)",
--     group = 29,
--     id = 66,
--     match = "man://sway(5)"
--   }
-- }
-- vim.api.nvim_create_autocmd('BufReadCmd', {
--   group = augroup,
--   pattern = 'man://*',
--   callback = function(params)
--     require('man').read_page(vim.fn.matchstr(params.match, 'man://\\zs.*'))
--   end,
-- })
