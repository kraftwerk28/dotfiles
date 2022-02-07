local utils = require("config.utils")
local highlight = utils.highlight
local colors = require("config.colors")

local fn, api = vim.fn, vim.api
local EMPTY_TAB_LABEL = [[ ¯\_(ツ)_/¯ ]]
local UNSAVED_MARK = "•"

local function tab_label(tabnr)
  local focused_win = api.nvim_tabpage_get_win(tabnr)
  local focused_buf = api.nvim_win_get_buf(focused_win)
  local bufname = api.nvim_buf_get_name(focused_buf)
  if bufname == "" then
    return EMPTY_TAB_LABEL
  end
  local tabpage_wins = vim.tbl_filter(
    function(winnr)
      return api.nvim_win_get_config(winnr).relative == ""
    end,
    api.nvim_tabpage_list_wins(tabnr)
  )
  local text = fn.fnamemodify(bufname, ":t")
  if #tabpage_wins > 1 then
    text = #tabpage_wins.." "..text
  end
  if api.nvim_buf_get_option(focused_buf, "modified") then
    text = UNSAVED_MARK..text
  end
  return " "..text.." "
end

local function build_tabline()
  local current_tab = api.nvim_get_current_tabpage()
  local str = ""
  for i, tab_nr in ipairs(api.nvim_list_tabpages()) do
    local hl_group = tab_nr == current_tab and "TabLineSel" or "TabLine"
    str = str.."%#"..hl_group.."#%"..i.."T"..tab_label(tab_nr)
  end
  str = str .. "%#TabLineFill#"
  return str
end

return function()
  local fnname = "tabline_build_tabline"
  _G[fnname] = build_tabline
  vim.o.tabline = "%!v:lua."..fnname.."()"
  -- TabLine - tab pages line, not active tab page label
  -- TabLineFill - tab pages line, where there are no labels
  -- TabLineSel - tab pages line, active tab page label
  -- highlight {"TabLine", guibg = "bg", gui = "NONE", bang = true}
  -- highlight {"TabLineFill", guibg = "bg", gui = "NONE", bang = true}
  -- highlight {
  --   "TabLineSel",
  --   guibg = cl.normal,
  --   guifg = cl.bg,
  --   gui   = "bold",
  --   bang  = true,
  -- }
  -- highlight {'TabLineSel', 'StatusLineModeInv', bang = true}
end
