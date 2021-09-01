local M = {}

local utils = require("utils")
local highlight = require("vim.highlight")
local load = utils.load
local fn = vim.fn

vim.g.mapleader = " "
vim.g.neovide_refresh_rate = 60
vim.g.floatwin_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}

require('lsp_handlers').patch_lsp_handlers()

load("theme")
load("mappings")
load("opts")
load("plugins")
load("tabline")
load("statusline")

vim.o.statusline = "%!v:lua._stl()"

if fn.has("unix") == 1 then
  -- Clicking any link pointing to neovim or vim docs site
  -- will open :help split in existing neovim session, if any
  -- (required corresponding .desktop file which replaces browser
  pcall(fn.serverstart, "localhost:" .. (vim.env.NVIM_LISTEN_PORT or 6969))
end

M.format_code = utils.format_code

function M.save_session()
  vim.cmd("mks")
end

function M.restore_session()
  if fn.filereadable("Session.vim") == 0 then
    return
  end
  vim.cmd("source Session.vim")
  if fn.bufexists(1) == 1 then
    for i = 1, fn.bufnr("$") do
      if fn.bufwinnr(i) == -1 then
        vim.cmd("sbuffer "..i)
      end
    end
  end
end

function M.show_line_diagnostics()
  vim.lsp.diagnostic.show_line_diagnostics({ border = vim.g.floatwin_border })
end

function M.yank_highlight()
  if highlight ~= nil then
    highlight.on_yank {timeout = 1000}
  end
end

utils.nnoremap("<Leader>ar", function()
  local _, line_num, col_num, _, _ = unpack(fn.getcurpos())
  line_num = line_num - 1
  col_num = col_num - 1

  -- local bufnum, start_row, start_col, _ = unpack(fn.getpos("'<"))
  -- local _, end_row, end_col, _ = unpack(fn.getpos("'>"))
  -- start_row = start_row - 1
  -- start_col = start_col - 1
  -- end_row = end_row - 1

  local parser = vim.treesitter.get_parser()
  local root_node = parser:parse()[1]:root()

  local arguments_node =
    root_node:named_descendant_for_range(line_num, col_num, line_num, col_num)
  while true do
    local type = arguments_node:type()
    if arguments_node == root_node then
      print("Not inside arguments")
      return
    elseif type ~= "arguments" then
      arguments_node = arguments_node:parent()
    else
      break
    end
  end

  local child_count= arguments_node:named_child_count()
  for i = 0, child_count - 1 do
    local child = arguments_node:named_child(i)
    local line, col, e_line, e_col = child:range()
    print(("%s; [%d %d, %d, %d]"):format(child:type(), line, col, e_line, e_col))
    fn.cursor(line+1, col+1)
    break
  end
  -- for child in arguments_node:iter_children() do
  --   if child:named() then
  --     print("Child type: "..child:type())
  --     print("Child sexpr: "..child:sexpr())
  --     print(child:range())
  --   end
  -- end

end)

-- local tm = vim.loop.new_timer()
-- local count = 0
-- tm:start(1000, 1000, vim.schedule_wrap(function()
--   count = count + 1
--   dump{count, fn.getpos("'<"), fn.getpos("'>")}
-- end))

return M
