local min_version = "nvim-0.8"
if vim.fn.has(min_version) == 0 then
  print("At least " .. min_version .. " is required for this config.")
  return
end

require("kraftwerk28.globals")

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
vim.cmd.runtime("opts.vim")

local function load(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

-- Disable clang's preprocessor highlighting, i.e. `#if 0 ... #endif`
vim.api.nvim_set_hl(
  0,
  "@lsp.type.comment.c",
  { fg = "NONE", bg = "NONE", sp = "NONE" }
)

vim.api.nvim_set_hl(
  0,
  "@lsp.type.comment.cpp",
  { fg = "NONE", bg = "NONE", sp = "NONE" }
)

load("kraftwerk28.theme")
load("kraftwerk28.map")
load("kraftwerk28.autocommand")
load("kraftwerk28.lsp")
load("kraftwerk28.lsp.servers")
load("kraftwerk28.lsp.manage")
load("kraftwerk28.tabline")
-- load("kraftwerk28.statusline")
load("kraftwerk28.filetype")
load("kraftwerk28.notify")
load("kraftwerk28.linenumber")
load("kraftwerk28.plugins")
-- load("kraftwerk28.netrw")

-- Redraw manpage for the current window width
do
  local resize_timer, resized_winids

  local function redraw_manpages()
    if resized_winids == nil then
      return
    end
    local current_winid = vim.api.nvim_get_current_win()
    for _, winid in ipairs(resized_winids) do
      if vim.api.nvim_win_is_valid(winid) then
        local buf = vim.api.nvim_win_get_buf(winid)
        if vim.bo[buf].filetype == "man" and vim.b[buf].pager == false then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local ref = vim.fn.matchstr(bufname, "man://\\zs.*")
          if ref ~= "" then
            vim.api.nvim_set_current_win(winid)
            local winview = vim.fn.winsaveview()
            pcall(require("man").read_page, ref)
            vim.fn.winrestview(winview)
          end
        end
      end
    end
    vim.api.nvim_set_current_win(current_winid)
    resize_timer, resized_winids = nil, nil
  end

  vim.api.nvim_create_autocmd("WinResized", {
    callback = function()
      if resize_timer ~= nil then
        resize_timer:stop()
      end
      resized_winids = vim.v.event.windows
      resize_timer =
        vim.defer_fn(redraw_manpages, vim.g.man_redraw_debounce_ms or 1000)
    end,
  })
end
