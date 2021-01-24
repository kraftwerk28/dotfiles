local gl = require 'galaxyline'
local gls = gl.section
local fileinfo = require 'galaxyline.provider_fileinfo'
local u = require'utils'.u

gl.short_line_list = {'NvimTree', 'vista', 'dbui'}

local cl = {
  dark0_hard = '#1d2021',
  dark0 = '#282828',
  dark0_soft = '#32302f',
  dark1 = '#3c3836',
  dark2 = '#504945',
  dark3 = '#665c54',
  dark4 = '#7c6f64',
  dark4_256 = '#7c6f64',

  gray_245 = '#928374',
  gray_244 = '#928374',

  light0_hard = '#f9f5d7',
  light0 = '#fbf1c7',
  light0_soft = '#f2e5bc',
  light1 = '#ebdbb2',
  light2 = '#d5c4a1',
  light3 = '#bdae93',
  light4 = '#a89984',
  light4_256 = '#a89984',

  bright_red = '#fb4934',
  bright_green = '#b8bb26',
  bright_yellow = '#fabd2f',
  bright_blue = '#83a598',
  bright_purple = '#d3869b',
  bright_aqua = '#8ec07c',
  bright_orange = '#fe8019',

  neutral_red = '#cc241d',
  neutral_green = '#98971a',
  neutral_yellow = '#d79921',
  neutral_blue = '#458588',
  neutral_purple = '#b16286',
  neutral_aqua = '#689d6a',
  neutral_orange = '#d65d0e',

  faded_red = '#9d0006',
  faded_green = '#79740e',
  faded_yellow = '#b57614',
  faded_blue = '#076678',
  faded_purple = '#8f3f71',
  faded_aqua = '#427b58',
  faded_orange = '#af3a03',

  none = 'NONE',
}
cl.bg = cl.dark1
cl.fg = cl.light0

local mode_map = {
  ['n'] = {'NORMAL', cl.bright_green},
  ['i'] = {'INSERT', cl.bright_blue},
  ['R'] = {'REPLACE', cl.bright_red},
  ['v'] = {'VISUAL', cl.bright_purple},
  ['V'] = {'V-LINE', cl.bright_purple},
  ['c'] = {'COMMAND', cl.bright_yellow},
  ['s'] = {'SELECT', cl.bright_purple},
  ['S'] = {'S-LINE', cl.bright_purple},
  ['t'] = {'TERMINAL', cl.bright_aqua},
  [''] = {'V-BLOCK', cl.bright_purple},
  [''] = {'S-BLOCK', cl.bright_purple},
  ['Rv'] = {'VIRTUAL'},
  ['rm'] = {'--MORE'},
}

local sep = {
  right_filled = u 'e0b2',
  left_filled = u 'e0b0',
  right = u 'e0b3',
  left = u 'e0b1',
}

local icons = {
  locker = u 'f023',
  unsaved = u 'f693',
  dos = u 'e70f',
  unix = u 'f17c',
  mac = u 'f179',
}

local function mode_label() return mode_map[vim.fn.mode()][1] or 'N/A' end
local function mode_hl() return mode_map[vim.fn.mode()][2] or cl.none end

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand '%:t') ~= 1 then return true end
  return false
end

local function diagnostic_exists()
  return vim.tbl_isempty(vim.lsp.buf_get_clients(0))
end

local function checkwidth()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then return true end
  return false
end

local function space() return ' ' end

gls.left[1] = {
  ViMode = {
    provider = function()
      vim.cmd(
        'highlight GalaxyViMode guifg=' .. cl.bg .. ' guibg=' .. mode_hl() ..
          ' gui=bold')
      vim.cmd('highlight GalaxyViModeInv guifg=' .. mode_hl() .. ' guibg=' ..
                cl.bg .. ' gui=bold')
      return string.format('  %s ', mode_label())
    end,
    separator = sep.left_filled,
    separator_highlight = 'GalaxyViModeInv',
  },
}

gls.left[2] = {
  FileIconLeft = {
    provider = {space, 'FileIcon'},
    highlight = {fileinfo.get_file_icon_color, cl.bg},
    condition = buffer_not_empty,
  },
}

gls.left[3] = {
  FileLeft = {
    provider = function()
      local f = vim.fn.expand('%:t')
      if #f == 0 then return '' end
      if vim.bo.readonly then f = f .. ' ' .. icons.locker end
      if vim.bo.modified then f = f .. ' ' .. icons.unsaved end
      f = f .. ' '
      return f
    end,
    condition = buffer_not_empty,
    highlight = {cl.fg, cl.bg},
    separator = sep.left,
    separator_highlight = 'GalaxyViModeInv',
  },
}

gls.right[2] = {
  DiagnosticWarn = {
    provider = function()
      local n = vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Warning')
      if n == 0 then return '' end
      return string.format(' %s %d ', u 'f071', n)
    end,
    highlight = {cl.bright_yellow, cl.bg},
    separator = sep.right,
    separator_highlight = 'GalaxyViModeInv',
  },
  DiagnosticError = {
    provider = function()
      local n = vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Error')
      if n == 0 then return '' end
      return string.format(' %s %d ', u 'e009', n)
    end,
    highlight = {cl.bright_red, cl.bg},
  },
}

gls.right[3] = {
  FileType = {
    provider = function()
      local icon = icons[vim.bo.fileformat] or ''
      return string.format(' %s %s ', icon, vim.bo.filetype)
    end,
    highlight = {cl.bright_orange, cl.bg},
    separator = sep.right,
    separator_highlight = 'GalaxyViModeInv',
  },
}

gls.right[4] = {
  PositionInfo = {
    provider = {
      function()
        return string.format(' %s:%s ', vim.fn.line('.'), vim.fn.col('.'))
      end,
    },
    highlight = 'GalaxyViMode',
    condition = buffer_not_empty,
    separator = sep.right_filled,
    separator_highlight = 'GalaxyViModeInv',
  },
}

gls.right[5] = {
  PercentInfo = {
    provider = fileinfo.current_line_percent,
    highlight = 'GalaxyViMode',
    condition = buffer_not_empty,
    separator = sep.right,
    separator_highlight = 'GalaxyViMode',
  },
}
