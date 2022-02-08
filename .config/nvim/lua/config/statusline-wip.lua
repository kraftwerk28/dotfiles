local utils = require("config.utils")
local api, fn = vim.api, vim.fn
local devicons = require("nvim-web-devicons")
local ts = require("nvim-treesitter")

-- local devicon_hl = setmetatable({}, {
--   __index = function(t, key)
--     local devicon_highlight = rawget(t, key)
--     if devicon_highlight then return devicon_highlight end
--     local hl = utils.get_highlight(key)
--   end,
-- });

-- local mode_labels = {
--   {{"n", "niI", "niR", "niV",	"nt"},  "NORMAL"},
--   {{"no", "nov", "noV", "no"},  "OPERATOR"},
--   {{"v", "vs"},  "VISUAL"},
--   {{"V", "Vs"},  "V-LINE"},
--   {{"", "s"}, "V-BLOCK"},
--   {{"s"},  "SELECT"},
--   {{"S"},  "S-LINE"},
--   {{""}, "S-BLOCK"},
--   {{"i", "ic", "ix"},  "INSERT"},
--   {{"R", "Rc", "Rx", "Rv", "Rvc", "Rvx"},  "REPLACE"},
--   {{"c", "cv"},  "COMMAND"},
--   {{"t"},  "TERMINAL"},
--   {{"r"}, "HIT-ENTER"},
--   {{"rm"}, "MORE"},
-- }

local format_icons = { dos = " ", mac = " ", unix = " " }

local stl_hl = {
  stl = utils.get_highlight("StatusLine"),
  stl_nc = utils.get_highlight("StatusLineNC"),
  cache = {},
}
do
  local on_colors_load = utils.defglobalfn(function()
    stl_hl.stl    = utils.get_highlight("StatusLine")
    stl_hl.stl_nc = utils.get_highlight("StatusLineNC")
    for hl, _ in pairs(stl_hl.cache) do
      stl_hl:load(hl)
    end
  end)
  vim.cmd("autocmd ColorScheme * call v:lua."..on_colors_load.."()")
end
function stl_hl:load(name)
  local hl = utils.get_highlight(name)
  utils.highlight {
    "Stl"..name,
    guifg = hl.guifg,
    guibg = self.stl.guibg,
    guisp = hl.guisp,
    gui   = hl.gui,
  }
  utils.highlight {
    "Stl"..name.."NC",
    guifg = hl.guifg,
    guibg = self.stl_nc.guibg,
    guisp = hl.guisp,
    gui   = hl.gui,
  }
end
function stl_hl:get(name, focused)
  if not self.cache[name] then
    self:load(name)
    self.cache[name] = true
  end
  return focused and "Stl"..name or "Stl"..name.."NC"
end

local Statusline = {}
Statusline.__index = Statusline
function Statusline:new(focused)
  return setmetatable({ parts = {}, focused = focused }, self)
end
function Statusline:add(opts)
  local body = opts[1]
  local res
  if type(body) == "function" then
    local wrap = utils.defglobalfn(function() return body() or "" end)
    if opts.eval then res = "%{%v:lua."..wrap.."()%}"
    else res = "%{v:lua."..wrap.."()}" end
  else
    res = body
  end
  if opts.highlight then
    res = "%#"..stl_hl:get(opts.highlight, self.focused).."#"..res.."%*"
  end
  table.insert(self.parts, res)
end
function Statusline:sep()
  table.insert(self.parts, "%=")
end
function Statusline:group(f)
  table.insert(self.parts, "%(")
  f()
  table.insert(self.parts, "%)")
end
function Statusline:space(n)
  table.insert(self.parts, (" "):rep(n or 1))
end
function Statusline:render()
  return table.concat(self.parts, "")
end

local function make_stl(focused)
  local stl = Statusline:new(focused)

  stl:space()
  stl:add {function() return format_icons[vim.bo.fileformat] end}
  stl:space()
  stl:add {function() return #vim.bo.filetype > 0 and vim.bo.filetype end}

  stl:sep()

  stl:space()
  stl:add {function()
    local filename, fileext = fn.expand("%:t"), fn.expand("%:e")
    local icon, icon_highlight = devicons.get_icon(filename, fileext)
    if icon then
      return "%#"..stl_hl:get(icon_highlight, focused).."#"..icon.."%*"
    end
  end, eval = true}
  stl:space()
  stl:add {"%f"}
  stl:group(function()
    stl:add {function() return vim.bo.modified and "  " end}
    stl:add {function() return vim.bo.readonly and "  " end}
  end)

  stl:sep()

  if focused then
    stl:add {function()
      local ts_stl = ts.statusline()
      if ts_stl and #ts_stl > 0 then
        return " %<%#User2#" .. ts_stl .. "%*"
      end
    end, eval = true}
  end

  stl:group(function()
    stl:space()
    stl:add {function()
      if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return "%#"..stl_hl:get("NvimIdentifier", focused).."# %*"
      else
        return "%#"..stl_hl:get("NvimString", focused).."# %*"
      end
    end, eval = true}
    for _, it in ipairs {
      { "DiagnosticError", "ERROR" },
      { "DiagnosticWarn",  "WARN"  },
      { "DiagnosticInfo",  "INFO"  },
      { "DiagnosticHint",  "HINT"  },
    } do
      stl:add {function()
        local count = #vim.diagnostic.get(0, {
          severity = vim.diagnostic.severity[it[2]]
        })
        if count > 0 then
          return vim.g.diagnostic_signs[it[2]]..count.." "
        end
      end, highlight = it[1]}
    end
  end)

  if focused then
    stl:add {"(0x%04.B)"}
    stl:space()
    stl:add {"%4.l/%-4.L:%3.c"}
  end

  stl:space()
  return stl:render()
end

--[[
local make_stl_ = utils.defglobalfn(function(focused)
  local stl = Statusline:new(focused)

  -- if focused then
  --   local cur_mode, mode_label = fn.mode()
  --   for _, moddef in ipairs(mode_labels) do
  --     if vim.tbl_contains(moddef[1], cur_mode) then
  --       mode_label = moddef[2]
  --       break
  --     end
  --   end
  --   stl:add(mode_label)
  -- end
  -- stl:sep()

  stl:add(format_icons[vim.bo.fileformat])
  stl:add(#vim.bo.filetype > 0 and vim.bo.filetype or "-")

  stl:sep()

  local filename, fileext = fn.expand("%:t"), fn.expand("%:e")
  local icon, icon_highlight = devicons.get_icon(filename, fileext)
  if icon then stl:add(icon, icon_highlight) end
  stl:add("%f")
  if vim.bo.modified then
    stl:add("  ")
  end
  if vim.bo.readonly then
    stl:add("  ")
  end

  -- *nvim_treesitter#statusline()*
  -- nvim_treesitter#statusline(opts)~
  -- Returns a string describing the current position in the file. This
  -- could be used as a statusline indicator.
  -- Default options (lua syntax):
  --   {
  --     indicator_size = 100,
  --     type_patterns = {'class', 'function', 'method'},
  --     transform_fn = function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
  --     separator = ' -> '
  --   }
  -- - `indicator_size` - How long should the string be. If longer, it is cut from
  --   the beginning.
  -- - `type_patterns` - Which node type patterns to match.
  -- - `transform_fn` - Function used to transform the single item in line. By
  --   default removes opening brackets and spaces from end.
  -- - `separator` - Separator between nodes.

  stl:sep()

  if focused then
    local ts_stl = ts.statusline()
    if ts_stl and #ts_stl > 0 then
      stl:add(" %<%#User2#" .. ts_stl .. "%* ")
    end
  end

  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    stl:add(" ", "NvimIdentifier")
  else
    stl:add(" ", "NvimString")
  end
  local lsp_nerr = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.E
  })
  if lsp_nerr > 0 then
    stl:add(" "..lsp_nerr, "LspDiagnosticsDefaultError")
  end
  local lsp_nwarn = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.W
  })
  if lsp_nwarn > 0 then
    stl:add(" "..lsp_nwarn, "LspDiagnosticsDefaultWarning")
  end

  if focused then
    stl:add("(0x%04.B) %4.l/%-4.L:%3.c")
  end

  return stl:render()
end)
]]

local stl1 = make_stl(true)
local stl2 = make_stl(false)
local stl_fn_name = utils.defglobalfn(function()
  if vim.g.statusline_winid == fn.win_getid(fn.winnr()) then
    return stl1
  else
    return stl2
  end
end)

vim.opt.statusline = "%!v:lua."..stl_fn_name.."()"
