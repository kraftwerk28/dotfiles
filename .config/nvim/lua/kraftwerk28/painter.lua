-- The purpose if this class is to solve vim's problem of highlight groups with
-- 'transparent' background. For example, the statusline by default has
-- StatusLine highlight group (StatusLineNC for an unfocused window). If we try
-- to put an element into it with a highlight before (i.e. %#HLname#sometext), whose
-- background doesn't match the background of StatusLine, it would create a
-- 'hole' in statusline row. By instantiating this class and indexing it's
-- instance with a highlight group, it'd generate a new one on the fly, with
-- matching background of 'base' highlight group. For example:
--
-- ```lua
-- local p = Painter:new({
--   base = "StatusLine",
--   get_name = function(name)
--     -- DiagnosticError -> StlDiagnosticError
--     return "Stl"..name
--   end,
-- })
-- local fixed_hl_group = p["DiagnosticError"]
-- vim.go.statusline = "%#" .. fixed_hl_group .. "#sometext"
-- ```
--

local Painter = {}

Painter.__index = function(self, key)
  return Painter[key] or Painter.generate(self, key)
end

function Painter:new(o)
  o = o or {}
  o.base_hl = vim.api.nvim_get_hl_by_name(o.base, true)
  o.cache = {}
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local cache = o.cache
      o.cache = {}
      o.base_hl = vim.api.nvim_get_hl_by_name(o.base, true)
      for name, _ in pairs(cache) do
        o:generate(name)
      end
    end,
  })
  return setmetatable(o, self)
end

function Painter:generate(name)
  if self.cache[name] ~= nil then
    return self.cache[name]
  end
  local new_name = self.get_name(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  vim.api.nvim_set_hl(0, new_name, self:merge_hl(hl))
  self.cache[name] = new_name
  return new_name
end

function Painter:merge_hl(hl)
  local bg
  if self.base_hl.reverse then
    bg = self.base_hl.foreground
  else
    bg = self.base_hl.background
  end
  return { fg = hl.foreground, bg = bg }
end

return Painter
