local M = {}
local api, fn = vim.api, vim.fn

local utils = require("config.utils")
local load = utils.load

_G.A = setmetatable({}, {
  __index = function(_, k)
    return vim.api["nvim_"..k]
  end
})

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
-- vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
vim.g.floatwin_border = {'┌', '─', '┐', '│', '┘', '─', '└', '│'}
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

api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local highlight = require("vim.highlight")
    if highlight then
      highlight.on_yank({ timeout = 1000 })
    end
  end,
})

do
  local no_line_number_ft = {"help", "man", "list", "TelescopePrompt"}
  local function set_nu(relative)
    return function()
      if fn.win_gettype() == "popup" then return end
      if vim.tbl_contains(no_line_number_ft, vim.bo.filetype) then
        return
      end
      vim.wo.number = true
      vim.wo.relativenumber = relative
    end
  end
  vim.api.nvim_create_autocmd("BufEnter,WinEnter,FocusGained", {
    callback = set_nu(true)
  })
  vim.api.nvim_create_autocmd("BufLeave,WinLeave,FocusLost", {
    callback = set_nu(false)
  })
end

do
  api.nvim_create_user_command(
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

  local function organize_imports()
    local params = vim.lsp.util.make_range_params()
    -- local lnum = vim.api.nvim_win_get_cursor(opts.winnr)[1]
    -- params.context = {
    --   diagnostics = vim.lsp.diagnostic.get_line_diagnostics(opts.bufnr, lnum - 1),
    -- }
    local result, err = vim.lsp.buf_request_sync(
      0,
      "textDocument/codeAction",
      params
    )
    if err then
      print("error", err)
      return
    end
    print(vim.inspect(result))
    -- TODO
    -- for _, r in pairs(result) do
    --   for _, cmd in ipairs(r.result) do
    --     if cmd.kind == "source.organizeImports" then
    --       vim.lsp.buf.execute_command(cmd)
    --       return
    --     end
    --   end
    -- end
  end

  -- vim.keymap.set("n", "<Leader>aoi", organize_imports, { noremap = true })
end

-- set 'makeprg' for some projects
if vim.fn.glob("meson.build") ~= "" then
  vim.o.makeprg = "meson compile -C build"
end
if vim.fn.glob("go.mod") ~= "" then
  vim.o.makeprg = "go build"
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.bo.filetype == "help" then
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

return M
