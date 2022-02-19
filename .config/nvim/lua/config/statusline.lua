local utils = require("config.utils")
local fn = vim.fn
local devicons = require("nvim-web-devicons")
local ts = require("nvim-treesitter")

-- Who needs mode label in statusline?
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
  utils.highlight(vim.tbl_extend("force", self.stl, {
    [1] = "Stl"..name,
    guifg = hl.guifg,
  }))
  utils.highlight(vim.tbl_extend("force", self.stl_nc, {
    [1] = "Stl"..name.."NC",
    guifg = hl.guifg,
  }))
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
  return setmetatable({ parts = {}, focused = focused, groups = {} }, self)
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
    res = "%#"..stl_hl:get(opts.highlight, self.focused).."#"..res
    if #self.groups == 0 then
      res = res.."%*" -- Reset highlight
    end
  end
  table.insert(self.parts, res)
end
function Statusline:sep()
  table.insert(self.parts, "%=")
end
function Statusline:group(f)
  table.insert(self.groups, true)
  table.insert(self.parts, "%(")
  f()
  table.insert(self.parts, "%)%*")
  table.remove(self.groups)
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
  stl:add {
    function()
      local filename, fileext = fn.expand("%:t"), fn.expand("%:e")
      local icon, icon_highlight = devicons.get_icon(filename, fileext)
      return icon
      -- if icon then
      --   return "%#"..stl_hl:get(icon_highlight, focused).."#"..icon.."%*"
      -- end
    end,
    -- eval = true,
  }
  stl:space()
  stl:add {"%f"}
  stl:group(function()
    stl:add {function() return vim.bo.modified and "  " end}
    stl:add {function() return vim.bo.readonly and "  " end}
  end)

  stl:sep()

  if focused then
    stl:add {
      function()
        local ts_stl = ts.statusline()
        if ts_stl and #ts_stl > 0 then
          return " %<%#User2#" .. ts_stl .. "%*"
        end
      end,
      eval = true,
    }
  end

  stl:group(function()
    stl:space()
    stl:add {
      function()
        if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
          return " "
          -- return "%#"..stl_hl:get("Error", focused).."# "
        else
          return " "
          -- return "%#"..stl_hl:get("NvimString", focused).."# "
        end
      end,
      -- eval = true,
    }
    for _, it in ipairs {
      { "DiagnosticError", "ERROR" },
      { "DiagnosticWarn",  "WARN"  },
      { "DiagnosticInfo",  "INFO"  },
      { "DiagnosticHint",  "HINT"  },
    } do
      stl:add {
        function()
          local count = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity[it[2]]
          })
          if count > 0 then
            return vim.g.diagnostic_signs[it[2]]..count.." "
          end
        end,
        -- highlight = it[1],
      }
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

local stl1 = make_stl(true)
local stl2 = make_stl(false)

local function stl()
  if vim.g.statusline_winid == fn.win_getid(fn.winnr()) then
    return stl1
  else
    return stl2
  end
end

vim.opt.statusline = "%!v:lua."..utils.defglobalfn(stl).."()"
