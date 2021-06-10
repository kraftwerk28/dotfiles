local colors = require('cfg.colors')
local utils = require('utils')
local devicons = require('nvim-web-devicons')
local stl = require('statusline.core')
local builtin = require('statusline.components')

local u = utils.u
local sprintf = utils.sprintf
local highlight = utils.highlight

local cl = colors.from_base16(vim.g.base16_theme)

local mode_map = {
  ['n'] = {'NORMAL', cl.normal},
  ['i'] = {'INSERT', cl.insert},
  ['R'] = {'REPLACE', cl.replace},
  ['v'] = {'VISUAL', cl.visual},
  ['V'] = {'V-LINE', cl.visual},
  ['c'] = {'COMMAND', cl.command},
  ['s'] = {'SELECT', cl.visual},
  ['S'] = {'S-LINE', cl.visual},
  ['t'] = {'TERMINAL', cl.terminal},
  [''] = {'V-BLOCK', cl.visual},
  [''] = {'S-BLOCK', cl.visual},
}

local icons = {
  locker = u 'f023',
  unsaved = u 'f693',
  dos = u 'e70f',
  unix = u 'f17c',
  mac = u 'f179',
  lsp_warn = u 'f071',
  lsp_error = u 'f46e',
  lsp_server_icon = u 'f817',
  lsp_server_disconnected = u 'f818',
  col_num = u 'e0a3',
  line_num = u 'e0a1',
}

local function stl_mode()
  local mode = vim.fn.mode()
  local mode_label, mode_color = unpack(mode_map[mode])
  highlight {'StatusLine', cl.fg, cl.bg, 'bold'}
  highlight {'StatusLineModeInv', mode_color, cl.bg, 'reverse,bold'}
  highlight {'StatusLineMode', mode_color, cl.bg, 'bold'}
  if vim.fn.winwidth(0) > 80 then
    return mode_label
  else
    return mode_label:sub(1, 1)
  end
end

local function fileicon()
  local filename = vim.fn.expand('%:t')
  local fileext = vim.fn.expand('%:e')
  local icon, icon_hl = devicons.get_icon(filename, fileext)
  -- local patched_hl_name = 'StlFileIcon_' .. fileext

  -- if icon_hl ~= nil and vim.fn.hlexists(patched_hl_name) == 0 then
  --     local fg = cl.fg
  --     if icon_hl ~= nil then fg = utils.hl_by_name(icon_hl).fg end
  --     highlight {patched_hl_name, fg, cl.bg}
  -- end

  local fg = cl.fg
  if icon_hl ~= nil then
    fg = utils.hl_by_name(icon_hl).fg
  end
  highlight {'StatusLineFileIcon', fg, cl.bg}
  -- highlight {'StatusLineFileIcon', patched_hl_name, bang = true}
  return icon and (icon .. ' ') or ''
end

local function format_icon() return icons[vim.bo.fileformat] or '' end

local function filetype() return vim.bo.filetype end

local function file_attrs()
  local result = ''
  if vim.bo.readonly then
    result = result .. ' ' .. icons.locker
  end
  if vim.bo.modified then
    result = result .. ' ' .. icons.unsaved
  end
  return result
end

local function lsp_connected()
  local connected = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  local icon = connected and icons.lsp_server_icon or
                 icons.lsp_server_disconnected
  local icon_cl = connected and cl.lsp_active or cl.lsp_inactive
  highlight {'StatusLineLspConn', icon_cl, cl.bg}
  return icon .. ' '
end

local function lsp_count(kind, icon)
  local n = vim.lsp.diagnostic.get_count(0, kind)
  if n == 0 then
    return nil
  end
  return icon .. ' ' .. n
end

local function lsp_warns() return lsp_count('Warning', icons.lsp_warn) end
local function lsp_errors() return lsp_count('Error', icons.lsp_error) end

local function percent()
  local cur, total = vim.fn.line '.', vim.fn.line '$'
  if cur == 1 then
    return ' Top'
  elseif cur == total then
    return ' Bot'
  else
    local frac = (cur / total) * 100
    local rounded = frac + 0.5 - (frac + 0.5) % 1
    return sprintf('% 3d%%', rounded)
  end
end

local function buf_nonempty()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local function iswide() return vim.fn.winwidth(0) > 80 end

local comp = stl.make_component

local function build_stl()
  -- Left
  local mode = comp {stl_mode, hl = 'StatusLineModeInv', padding = {2, 1}}
  local fileformat = comp {
    format_icon,
    hl = 'StatusLine',
    padding = {2, 0},
    condition = buf_nonempty,
  }
  local ft = comp {
    filetype,
    hl = 'StatusLine',
    condition = buf_nonempty,
    padding = {2, 1},
    right_separator = {'|', hl = 'StatusLineMode'},
  }

  -- Center
  local icon = comp {
    fileicon,
    hl = 'StatusLineFileIcon',
    condition = buf_nonempty,
  }
  local filename = comp {'%t', hl = 'StatusLine'}
  local fileattrs = comp {file_attrs, hl = 'StatusLine'}

  -- Right
  local lsp_conn = comp {lsp_connected, hl = 'StatusLineLspConn'}
  local lsp_w = comp {lsp_warns, hl = 'StatusLineWarning'}
  local lsp_e = comp {lsp_errors, hl = 'StatusLineError'}
  local col_row = comp {
    icons.line_num .. '%l ' .. icons.col_num .. '%c',
    hl = 'StatusLineModeInv',
    left_separator = {u '2590', hl = 'StatusLineMode'},
  }
  local pos_percent = comp {
    percent,
    condition = iswide,
    left_separator = {'|', hl = 'StatusLineModeInv'},
    padding = {0, 1},
  }

  return stl.combine_components(
    mode, fileformat, ft, builtin.reset_highlight,
      builtin.alignment_separator, icon, filename, fileattrs,
      builtin.alignment_separator, lsp_conn, lsp_w, lsp_e, col_row, pos_percent
  )
end

local function build_inactive_stl()
  local icon = comp {
    fileicon,
    hl = 'StatusLineFileIcon',
    condition = buf_nonempty,
  }
  local filename = comp {'%f', hl = 'StatusLine'}
  local fileattrs = comp {file_attrs, hl = 'StatusLine'}

  local lsp_conn = comp {lsp_connected, hl = 'StatusLineLspConn'}
  local lsp_w = comp {lsp_warns, hl = 'StatusLineWarning'}
  local lsp_e = comp {lsp_errors, hl = 'StatusLineError'}

  return stl.combine_components(
    builtin.reset_highlight, builtin.alignment_separator, icon, filename,
      fileattrs, builtin.alignment_separator, lsp_conn, lsp_w, lsp_e
  )
end

-- function _G.attach_primary_stl()
--     highlight {
--         'StatusLineWarning',
--         guibg = cl.bg,
--         override = 'LspDiagnosticsDefaultWarning',
--     }
--     highlight {
--         'StatusLineError',
--         guibg = cl.bg,
--         override = 'LspDiagnosticsDefaultError',
--     }
--     vim.wo.statusline = build_stl()
-- end

-- function _G.attach_secondary_stl() vim.wo.statusline = build_inactive_stl() end

local cached_primary_stl, cached_secondary_stl

function _G.get_cached_stl()
  if vim.g.statusline_winid == vim.fn.win_getid() then
    return cached_primary_stl
  else
    return cached_secondary_stl
  end
end

local function refresh_stl_cache()
  highlight {
    'StatusLineWarning',
    guibg = cl.bg,
    override = 'LspDiagnosticsDefaultWarning',
  }
  highlight {
    'StatusLineError',
    guibg = cl.bg,
    override = 'LspDiagnosticsDefaultError',
  }
  vim.opt.statusline = '%!v:lua.get_cached_stl()'
  cached_primary_stl = build_stl()
  cached_secondary_stl = build_inactive_stl()
end

_G.refresh_stl_cache = refresh_stl_cache

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

return function()
  local cmd = [[
    windo lua refresh_stl_cache()
    augroup stl_autocommands
      autocmd!
      autocmd BufEnter,WinEnter,BufLeave,WinLeave * lua refresh_stl_cache()
    augroup END
  ]]
  vim.api.nvim_exec(cmd, false)
end
