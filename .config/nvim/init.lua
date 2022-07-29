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
vim.g.floatwin_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
vim.g.floatwin_border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
-- stylua: ignore end
vim.g.diagnostic_signs = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = " ",
}
vim.g.sql_type_default = "sqlanywhere"

vim.cmd("runtime opts.vim")

local ok, err = pcall(function()
  -- require("github-theme").setup({
  --   theme_style = "dark_default",
  --   -- function_style = "italic",
  --   -- sidebars = { "qf", "vista_kind", "terminal", "packer" },
  --   colors = { hint = "orange", error = "#ff0000" },
  --   hide_inactive_statusline = false,
  -- })
  -- require("onedark").setup({ style = "darker" })
  -- require("onedark").load()

  -- local colorscheme = "github_dark_default"
  local colorscheme = "kanagawa"
  -- local colorscheme = "base16-gruvbox-light-medium"
  vim.cmd("colorscheme " .. colorscheme)
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

-- if fn.has("unix") == 1 then
--   -- Clicking any link pointing to neovim or vim docs site
--   -- will open :help split in existing neovim session, if any
--   -- (required corresponding .desktop file which replaces browser
--   pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
-- end

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

--[[
local vt_ns_ids = {}
-- local old_vt_show = vim.diagnostic.handlers.virtual_text.show
-- local old_vt_hide = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers["virtual_text"] = {
  show = function(namespace, bufnr, diagnostics, opts)
    local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    local margin = 4
    local virt_text_win_col = 0

    if not bufnr or bufnr == 0 then
      bufnr = vim.api.nvim_get_current_buf()
    end
    -- opts = opts or {}
    -- local x = ''
    -- y = ''

    local vt_ns_id = vim.api.nvim_create_namespace("")
    vt_ns_ids[namespace] = vt_ns_id
    local text_per_line = {}
    for _, d in ipairs(diagnostics) do
      local diag_messages = text_per_line[d.lnum] or {}
      local m = #buf_lines[d.lnum + 1] + margin
      if m > virt_text_win_col then
        virt_text_win_col = m
      end
      table.insert(diag_messages, d.message)
      text_per_line[d.lnum] = diag_messages
    end

    for line, texts in pairs(text_per_line) do
      vim.api.nvim_buf_set_extmark(bufnr, vt_ns_id, line, 0, {
        virt_text = vim.tbl_map(function(t)
          return { t, "Normal" }
        end, texts),
        virt_text_win_col = virt_text_win_col,
      })
    end
  end,
  hide = function(namespace, bufnr)
    local ns = vt_ns_ids[namespace]
    if ns then
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    end
  end,
}
]]
