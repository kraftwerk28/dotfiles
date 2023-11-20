local utils = require("kraftwerk28.utils")
local fn = vim.fn
local devicons = require("nvim-web-devicons")
local ts = require("nvim-treesitter")
local Painter = require("kraftwerk28.painter")

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

local Statusline = {}
Statusline.__index = Statusline

function Statusline:new(args)
  return setmetatable({
    parts = {},
    painter = args.painter,
    groups = {},
  }, self)
end

function Statusline:add(opts)
  local body = opts[1]
  local res
  if type(body) == "function" then
    local wrap = utils.defglobalfn(function()
      return body() or ""
    end)
    if opts.eval then
      res = "%{%v:lua." .. wrap .. "()%}"
    else
      res = "%{v:lua." .. wrap .. "()}"
    end
  else
    res = body
  end
  if opts.highlight then
    res = "%#" .. self.painter[opts.highlight] .. "#" .. res
    if #self.groups == 0 then
      res = res .. "%*" -- Reset highlight
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
  local painter
  if focused then
    painter = Painter:new({
      base = "StatusLine",
      get_name = function(name)
        return "Stl" .. name
      end,
    })
  else
    painter = Painter:new({
      base = "StatusLineNC",
      get_name = function(name)
        return "Stl" .. name .. "NC"
      end,
    })
  end

  local stl = Statusline:new({ painter = painter })

  stl:space()
  stl:add({
    function()
      return format_icons[vim.bo.fileformat]
    end,
  })
  stl:space()
  stl:add({
    function()
      return #vim.bo.filetype > 0 and vim.bo.filetype
    end,
  })

  stl:sep()

  stl:space()
  stl:add({
    function()
      local filename, fileext = fn.expand("%:t"), fn.expand("%:e")
      local icon, icon_highlight = devicons.get_icon(filename, fileext)
      if icon then
        local hl = painter[icon_highlight]
        return "%#" .. hl .. "#" .. icon .. "%*"
      end
    end,
    eval = true,
  })
  stl:space()
  stl:add({ "%f" })
  stl:group(function()
    stl:add({
      function()
        return vim.bo.modified and "  "
      end,
    })
    stl:add({
      function()
        return vim.bo.readonly and "  "
      end,
    })
  end)

  stl:sep()

  -- if focused then
  --   stl:add {
  --     function()
  --       local ts_stl = ts.statusline()
  --       if ts_stl and #ts_stl > 0 then
  --         return " %<%#User2#" .. ts_stl .. "%*"
  --       end
  --     end,
  --     eval = true,
  --   }
  -- end

  stl:group(function()
    stl:space()
    stl:add({
      function()
        if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
          return "%#" .. painter["Error"] .. "# "
        else
          return "%#" .. painter["String"] .. "# "
        end
      end,
      eval = true,
    })
    for _, it in ipairs({
      { "DiagnosticError", "ERROR" },
      { "DiagnosticWarn", "WARN" },
      { "DiagnosticInfo", "INFO" },
      { "DiagnosticHint", "HINT" },
    }) do
      local hl_name, diagnostic_name = it[1], it[2]
      stl:add({
        function()
          local count = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity[diagnostic_name],
          })
          if count > 0 then
            return vim.g.diagnostic_signs[diagnostic_name] .. count .. " "
          end
        end,
        highlight = hl_name,
      })
    end
  end)

  if focused then
    -- stl:add({
    --   function()
    --     local search = vim.fn.searchcount()
    --   end,
    -- })

    -- Character under cursor's hex
    stl:add({ "(0x%04.B)" })

    stl:space()

    -- current line / total lines : current column
    stl:add({ "%4.l/%-4.L:%3.c" })
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

-- vim.opt.laststatus = 0
-- vim.opt.winbar = "%!v:lua."..utils.defglobalfn(stl).."()"
vim.go.statusline = "%!v:lua." .. utils.defglobalfn(stl) .. "()"
