local utils = require("utils")
local highlight = utils.highlight
local colors = require("cfg.colors")

local fn = vim.fn
local u = utils.u

local function tab_label(i)
  local buflist = fn.tabpagebuflist(i)
  local winnr = fn.tabpagewinnr(i)
  local bufname = fn.bufname(buflist[winnr])
  if bufname == "" then
    return " ¯\\_(ツ)_/¯ "
  end
  local text = fn.fnamemodify(bufname, ":t")
  if #buflist > 1 then
    text = #buflist.." "..text
  end
  for _, bufnr in ipairs(buflist) do
    if fn.getbufvar(bufnr, "&mod") == 1 then
      text = "•"..text
      break
    end
  end
  return " "..text.." "
end

local function build_tabline()
  local current_tab = fn.tabpagenr()
  local str = ""
  for i = 1, fn.tabpagenr("$") do
    local hl_group = i == current_tab and "TabLineSel" or "TabLine"
    str = str.."%#"..hl_group.."#%"..i.."T"..tab_label(i)
  end
  str = str .. "%#TabLineFill#"
  return str
end

return function()
  local cl = colors.from_base16(vim.g.base16_theme)
  _G.tabline_build_tabline = build_tabline
  vim.o.tabline = "%!v:lua.tabline_build_tabline()"
  -- TabLine - tab pages line, not active tab page label
  -- TabLineFill - tab pages line, where there are no labels
  -- TabLineSel - tab pages line, active tab page label
  highlight {"TabLine", guibg = "bg", gui = "NONE", bang = true}
  highlight {"TabLineFill", guibg = "bg", gui = "NONE", bang = true}
  highlight {
    "TabLineSel",
    bg = cl.normal,
    fg = cl.bg,
    gui = "bold",
    bang = true,
  }
  -- highlight {'TabLineSel', 'StatusLineModeInv', bang = true}
end
