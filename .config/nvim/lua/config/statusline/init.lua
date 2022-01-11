local colors = require('config.colors')
local utils = require('config.utils')
local devicons = require('nvim-web-devicons')
local stl = require('config.statusline.core')

local u = utils.u
local sprintf = utils.sprintf
local highlight = utils.highlight
local component = stl.component
local severity = vim.diagnostic.severity

local mode_labels -- mode labels & colors
local cl -- colors

local icons = {
  locker = u"f023",
  unsaved = u"f693",
  dos = u"e70f",
  unix = u"f17c",
  mac = u"f179",
  lsp_warn = u"f071",
  lsp_error = u"f46e",
  lsp_hint = u"f0eb",
  lsp_information = u"f129",
  lsp_server_icon = u"f817",
  lsp_server_disconnected = u"f818",
  col_num = u"e0a3",
  line_num = u"e0a1",
}

local function lsp_count(severity, icon)
  local n = #vim.diagnostic.get(0, {severity = severity})
  if n == 0 then
    return nil
  end
  return icon .. ' ' .. n
end

local function buf_nonempty()
  return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

local function iswide()
  return vim.fn.winwidth(0) > 80
end

-- Left
local mode = component {
  function()
    local mode = vim.fn.mode()
    local mode_label, mode_color
    for _, mm in ipairs(mode_labels) do
      if vim.tbl_contains(mm[1], mode) then
        mode_label, mode_color = mm[2], mm[3]
        break
      end
    end
    -- local mode_label, mode_color = unpack(
    --   mode_map[mode] or {"NORMAL", cl.normal}
    -- )
    highlight {
      "StatusLine",
      guifg = cl.fg,
      guibg = cl.bg,
      gui = "bold",
    }
    highlight {
      "StatusLineModeInv",
      guifg = mode_color,
      guibg = cl.bg,
      gui = "reverse,bold",
    }
    highlight {
      "StatusLineMode",
      guifg = mode_color,
      guibg = cl.bg,
      gui = "bold",
    }
    if vim.fn.winwidth(0) > 80 then
      return mode_label
    else
      return mode_label:sub(1, 1)
    end
  end,
  highlight = "StatusLineModeInv",
  padding = {2, 1}
}

local fileformat = component {
  function()
    return icons[vim.opt.fileformat:get()] or ""
  end,
  highlight = "StatusLine",
  padding = {2, 0},
  condition = buf_nonempty,
}

local ft = component {
  function()
    return vim.opt.filetype:get()
  end,
  highlight = "StatusLine",
  condition = buf_nonempty,
  padding = {2, 1},
  right_separator = {'|', highlight = "StatusLineMode"},
}

-- Center
local icon = component {
  function()
    local filename = vim.fn.expand("%:t")
    local fileext = vim.fn.expand("%:e")
    local icon = devicons.get_icon(filename, fileext)
    return icon and (icon .. ' ') or ''
  end,
  on_focus_change = function()
    local filename = vim.fn.expand("%:t")
    local fileext = vim.fn.expand("%:e")
    local _, icon_highlight = devicons.get_icon(filename, fileext)
    local fg = cl.fg
    if icon_highlight ~= nil then
      fg = utils.hl_by_name(icon_highlight).fg
    end
    highlight {"StatusLineFileIcon", guifg = fg, guibg = cl.bg}
  end,
  highlight = "StatusLineFileIcon",
  condition = buf_nonempty,
}

local icon_inactive = component {
  function()
    local filename = vim.fn.expand("%:t")
    local fileext = vim.fn.expand("%:e")
    local icon = devicons.get_icon(filename, fileext)
    return icon and (icon .. " ") or ""
  end,
  condition = buf_nonempty,
}

local filename = component {"%t", highlight = "StatusLine"}

local fileattrs = component {
  function()
    local result = ""
    if vim.opt.readonly:get() then
      result = result .. " " .. icons.locker
    end
    if vim.opt.modified:get() then
      result = result .. " " .. icons.unsaved
    end
    return result
  end,
  highlight = "StatusLine",
}

-- Right
local lsp_conn = component {
  function()
    local connected = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
    local icon = connected and icons.lsp_server_icon or
                   icons.lsp_server_disconnected
    local icon_cl = connected and cl.lsp_active or cl.lsp_inactive
    highlight {"StatusLineLspConn", guifg = icon_cl, guibg = cl.bg}
    return icon .. ' '
  end,
  highlight = "StatusLineLspConn",
}

local lsp_w = component {
  function() return lsp_count(severity.WARNING, icons.lsp_warn) end,
  padding = 1,
  highlight = "StatusLineWarning",
}

local lsp_e = component {
  function() return lsp_count(severity.ERROR, icons.lsp_error) end,
  padding = 1,
  highlight = "StatusLineError",
}

local lsp_h = component {
  function() return lsp_count(severity.HINT, icons.lsp_hint) end,
  padding = 1,
  highlight = "StatusLineHint",
}

local lsp_i = component {
  function() return lsp_count(severity.INFO, icons.lsp_information) end,
  padding = 1,
  highlight = "StatusLineInformation",
}

local col_row = component {
  icons.line_num .. '%l ' .. icons.col_num .. '%c',
  highlight = "StatusLineModeInv",
  left_separator = {u"2590", highlight = "StatusLineMode"},
}

local pos_percent = component {
  function()
    local cur, total = vim.fn.line '.', vim.fn.line '$'
    if cur == 1 then
      return " Top"
    elseif cur == total then
      return " Bot"
    else
      local frac = (cur / total) * 100
      local rounded = frac + 0.5 - (frac + 0.5) % 1
      return sprintf("% 3d%%", rounded)
    end
  end,
  condition = iswide,
  left_separator = {'|', highlight = "StatusLineModeInv"},
  padding = {0, 1},
}

local secondary_filename = component {'%f', highlight = "StatusLine"}

return function()
  cl = colors.from_base16(vim.g.base16_theme)
  mode_labels = {
    {{"n"},  "NORMAL", cl.normal},
    {{"i"},  "INSERT", cl.insert},
    {{"R"},  "REPLACE", cl.replace},
    {{"v"},  "VISUAL", cl.visual},
    {{"V"},  "V-LINE", cl.visual},
    {{"c"},  "COMMAND", cl.command},
    {{"s"},  "SELECT", cl.visual},
    {{"S"},  "S-LINE", cl.visual},
    {{"t"},  "TERMINAL", cl.terminal},
    {{""}, "V-BLOCK", cl.visual},
    {{""}, "S-BLOCK", cl.visual},
  }

  stl.setup {
    on_update = function()
      highlight {
        "StatusLineWarning",
        guibg = cl.bg,
        override = "DiagnosticWarn",
        gui = "bold",
      }
      highlight {
        "StatusLineError",
        guibg = cl.bg,
        override = "DiagnosticError",
        gui = "bold",
      }
      highlight {
        "StatusLineHint",
        guibg = cl.bg,
        override = "DiagnosticHint",
        gui = "bold",
      }
      highlight {
        "StatusLineInformation",
        guibg = cl.bg,
        override = "DiagnosticInfo",
        gui = "bold",
      }
    end,
    primary = {
      {mode, fileformat, ft},
      {icon, filename, fileattrs},
      {lsp_conn, lsp_i, lsp_h, lsp_w, lsp_e, col_row, pos_percent},
    },
    secondary = {
      {},
      {icon_inactive, secondary_filename, fileattrs},
      {lsp_conn, lsp_w, lsp_e},
    },
  }
end

-- local frames = {
--   '', '', '', '', '', '', '', '', '', '', '',
--   '', '', '', '', '', '', '', '', '', '', '',
--   '', '', '', '', '', '',
-- }
-- TODO: make spinner components for status feedback
-- local function make_spinner()
--   local frames = {'/', '-', '\\', '|'}
--   local nthframe = 0
--   local function update_spinner()
--     nthframe = (nthframe + 1) % #frames
--     -- Note: no :redrawstatus here
--   end
--   vim.fn.timer_start(200, update_spinner, {['repeat'] = -1})
--   return function() return frames[nthframe + 1] end
-- end
