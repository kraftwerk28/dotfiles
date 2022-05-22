local utils = require("config.utils")
local M = {}

M.ayu_dark, M.ayu_mirage = (function()
  local ayu_colors = {
    bg = { dark = "#0F1419", light = "#FAFAFA", mirage = "#212733" },
    comment = { dark = "#5C6773", light = "#ABB0B6", mirage = "#5C6773" },
    markup = { dark = "#F07178", light = "#F07178", mirage = "#F07178" },
    constant = { dark = "#FFEE99", light = "#A37ACC", mirage = "#D4BFFF" },
    operator = { dark = "#E7C547", light = "#E7C547", mirage = "#80D4FF" },
    tag = { dark = "#36A3D9", light = "#36A3D9", mirage = "#5CCFE6" },
    regexp = { dark = "#95E6CB", light = "#4CBF99", mirage = "#95E6CB" },
    string = { dark = "#B8CC52", light = "#86B300", mirage = "#BBE67E" },
    _function = { dark = "#FFB454", light = "#F29718", mirage = "#FFD57F" },
    special = { dark = "#E6B673", light = "#E6B673", mirage = "#FFC44C" },
    keyword = { dark = "#FF7733", light = "#FF7733", mirage = "#FFAE57" },
    error = { dark = "#FF3333", light = "#FF3333", mirage = "#FF3333" },
    accent = { dark = "#F29718", light = "#FF6A00", mirage = "#FFCC66" },
    panel = { dark = "#14191F", light = "#FFFFFF", mirage = "#272D38" },
    guide = { dark = "#2D3640", light = "#D9D8D7", mirage = "#3D4751" },
    line = { dark = "#151A1E", light = "#F3F3F3", mirage = "#242B38" },
    selection = { dark = "#253340", light = "#F0EEE4", mirage = "#343F4C" },
    fg = { dark = "#E6E1CF", light = "#5C6773", mirage = "#D9D7CE" },
    fg_idle = { dark = "#3E4B59", light = "#828C99", mirage = "#607080" },
  }

  local ayu_mappings = {
    bg = ayu_colors.selection,
    fg = ayu_colors.fg,
    normal = ayu_colors.string,
    insert = ayu_colors.tag,
    replace = ayu_colors.markup,
    visual = ayu_colors.special,
    command = ayu_colors.keyword,
    terminal = ayu_colors.regexp,
    lsp_active = ayu_colors.string,
    lsp_inactive = ayu_colors.fg_idle,
    illuminate = { dark = "#3E4B59", mirage = "#3E4B59" },
  }

  local ayu_dark, ayu_mirage = {}, {}
  for k, v in pairs(ayu_mappings) do
    ayu_dark[k] = v.dark
    ayu_mirage[k] = v.mirage
  end
  return ayu_dark, ayu_mirage
end)()

M.onedark = {
  bg = "#545862",
  fg = "#c8ccd4",
  normal = "#98c379",
  insert = "#61afef",
  replace = "#e06c75",
  visual = "#e5c07b",
  command = "#d19a66",
  terminal = "#56b6c2",
  lsp_active = "#98c379",
  lsp_inactive = "#e06c75",
  illuminate = { dark = "#3E4B59", mirage = "#3E4B59" },
}

function M.from_base16(name)
  local base64 = require("base16-colorscheme")
  local theme = base64.colorschemes[name]
  local base_indexes = {
    bg = 0x02,
    fg = 0x07,
    normal = 0x0B,
    insert = 0x0D,
    replace = 0x08,
    visual = 0x0A,
    command = 0x09,
    terminal = 0x0C,
    lsp_active = 0x0B,
    lsp_inactive = 0x08,
  }
  local colors = {}
  for key, index in pairs(base_indexes) do
    colors[key] = theme["base" .. string.format("%02X", index)]
  end
  return colors
end

function M.define_highlights()
  local hl, get_hl = utils.highlight, utils.get_highlight
  local stl = get_hl("StatusLine")
  local tserror = get_hl("TSError")
  local tswarning = get_hl("TSWarning")

  hl({ "StatusLineLspError", guibg = stl.guibg, guifg = tserror.guifg })
  hl({ "StatusLineLspWarning", guibg = stl.guibg, guifg = tswarning.guifg })
end

return M
