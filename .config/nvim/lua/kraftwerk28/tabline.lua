local EMPTY_TAB_LABEL = [[ ¯\_(ツ)_/¯ ]]
local UNSAVED_MARK = "•"

local function tab_label(tabnr)
  local focused_win = api.nvim_tabpage_get_win(tabnr)
  local focused_buf = api.nvim_win_get_buf(focused_win)
  local bufname = api.nvim_buf_get_name(focused_buf)
  if bufname == "" then
    return EMPTY_TAB_LABEL
  end
  local tabpage_wins = vim.tbl_filter(function(winnr)
    return api.nvim_win_get_config(winnr).relative == ""
  end, api.nvim_tabpage_list_wins(tabnr))
  local text = fn.fnamemodify(bufname, ":t")
  if #tabpage_wins > 1 then
    text = #tabpage_wins .. " " .. text
  end
  if api.nvim_buf_get_option(focused_buf, "modified") then
    text = UNSAVED_MARK .. text
  end
  return " " .. text .. " "
end

local function get_tab_info(tabnr)
  local focused_winnr = vim.api.nvim_tabpage_get_win(tabnr)
  local focused_bufnr = vim.api.nvim_win_get_buf(focused_winnr)
  local focused_bufname = vim.api.nvim_buf_get_name(focused_bufnr)
  local unsaved = vim
    .iter(vim.api.nvim_tabpage_list_wins(tabnr))
    :any(function(winnr)
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      return vim.bo[bufnr].modified
    end)
  local path = vim.fn.fnamemodify(focused_bufname, ":."):gsub("([^/])[^/]+/", "%1/")
  return {
    path = path,
    empty = focused_bufname == "",
    unsaved = unsaved,
  }
end

function _G.build_tabline()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local str = ""
  for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local hl_group = tabnr == current_tab and "TabLineSel" or "TabLine"
    local info = get_tab_info(tabnr)
    local text
    if info.empty then
      text = " [Empty] "
    else
      text = " " .. info.path .. " "
    end
    if info.unsaved then
      text = " " .. UNSAVED_MARK .. text
    end
    str = str .. "%#" .. hl_group .. "#%" .. i .. "T" .. text
  end
  str = str .. "%#TabLineFill#"
  return str
end

local sel_hl = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
local fill_hl = vim.api.nvim_get_hl(0, { name = "TabLineFill", link = false })

vim.api.nvim_set_hl(
  0,
  "TabLineFill",
  vim.tbl_extend("force", fill_hl, { fg = sel_hl.fg })
)
vim.api.nvim_set_hl(
  0,
  "TabLineSel",
  vim.tbl_extend("force", sel_hl, { bold = true, reverse = true })
)

-- _G.SwitchBuffer = function(_, nclicks, button, modifiers)
--   vim.print({
--     nclicks = nclicks,
--     button = button,
--     modifiers = modifiers,
--   })
-- end

-- local tabline_sel = utils.get_highlight("TabLineSel")
-- tabline_sel.gui = "reverse,bold"
-- utils.highlight(tabline_sel)

vim.go.tabline = "%!v:lua.build_tabline()"
