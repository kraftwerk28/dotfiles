local M = {}

local utils = require("utils")
local sprintf = utils.sprintf
local api, fn = vim.api, vim.fn

-- @deprecated
-- local function get_padding(cfg)
--   local lp, rp = 0, 0
--   if cfg.padding ~= nil then
--     return cfg.padding, cfg.padding
--   end
--   if cfg.padl ~= nil then
--     lp = cfg.padl
--   end
--   if cfg.padr ~= nil then
--     rp = cfg.padr
--   end
--   if cfg.padding ~= nil then
--     lp = cfg.padding
--     rp = cfg.padding
--   end
--   return lp, rp
-- end

local on_focuschange_handlers = {}

local Builder = {}
Builder.__index = Builder

function Builder:new()
  return setmetatable({id_count = 0}, self)
end

function Builder:component(config)
  local result = ''
  local padl, padr = 0, 0
  if type(config.padding) == "table" and #config.padding >= 2 then
    padl, padr = unpack(config.padding)
  elseif type(config.padding) == "number" then
    padl, padr = config.padding, config.padding
  end

  local has_hl = type(config.hl) == "string"
  local has_condition = type(config.condition) == "function"

  local cond_fn
  if has_condition then
    cond_fn = config.condition
  end

  local cond_expr = ''
  if has_condition then
    local name = "_stl_cfn" .. self:next_id()
    _G[name] = cond_fn
    cond_expr = "v:lua." .. name .. "()"
  end

  -- Left separator
  local lsep = config.left_separator
  if lsep ~= nil then
    if lsep.hl ~= nil then
      result = result .. "%#" .. lsep.hl .. "#"
    end
    local sep = lsep[1] or lsep
    if has_condition then
      result = result .. sprintf("%%{%s ? '%s' : ''}", cond_expr, sep)
    else
      result = result .. sep
    end
  end

  if has_hl then
    result = result .. "%#" .. config.hl .. "#"
  end

  local render = config[1] or config.render
  if type(render) == "function" then
    result = result .. "%{"
    local padl_str = (" "):rep(padl)
    local padr_str = (" "):rep(padr)
    local fn_name = "_stl_fn" .. self:next_id()
    _G[fn_name] = function()
      local rendered = render()
      if rendered == nil then
        return ''
      end
      if has_condition and not cond_fn() then
        return ''
      end
      return padl_str .. rendered .. padr_str
    end
    result = result .. "v:lua." .. fn_name .. "()}"
  elseif type(render) == "string" then
    result = result .. ("\\ "):rep(padl) .. config[1] .. ("\\ "):rep(padr)
  else
    error("config[1] or config.render must be either function or string")
  end

  -- Right separator
  local rsep = config.right_separator
  if rsep ~= nil then
    if rsep.hl ~= nil then
      result = result .. "%#" .. rsep.hl .. "#"
    end
    local sep = rsep[1] or rsep
    if has_condition then
      result = sprintf("%s%%{%s ? '%s' : ''}", result, cond_expr, sep)
    else
      result = result .. sep
    end
  end

  if type(config.on_focus_change) == "function" then
    table.insert(on_focuschange_handlers, config.on_focus_change)
  end

  return result
end

-- Get unique ID for global scope functions
function Builder:next_id()
  self.id_count = self.id_count + 1
  return self.id_count
end

function M.make_string(sections)
  local section_str = {}
  for _, section in ipairs(sections) do
    table.insert(section_str, table.concat(section))
  end
  return table.concat(section_str, '%=')
end

M.Builder = Builder

local builder = Builder:new()
M.component = function(...) return builder:component(...) end

function M.setup(config)
  local primary, secondary = "", ""
  local get_cached_key = "_stl_get_cached"
  local update_stl_key = "_stl_update"
  local augroup_name = "stl_augroup"

  _G[get_cached_key] = function()
    if vim.g.statusline_winid == fn.win_getid() then
      return primary
    else
      return secondary
    end
  end

  _G[update_stl_key] = function()
    if type(config.on_update) == "function" then
      config.on_update()
    end
    for _, callback in ipairs(on_focuschange_handlers) do
      callback()
    end
    primary = M.make_string(config.primary)
    if type(config.secondary) == "table" then
      secondary = M.make_string(config.secondary)
    end
    vim.opt.statusline = ("%%!v:lua.%s()"):format(get_cached_key)
  end

  local update_events = {
    "BufEnter", "BufLeave",
    "WinEnter", "WinLeave",
  }

  local setup_au_cmd = ([[
    windo call v:lua.%s()
    augroup %s
      autocmd!
      autocmd %s * call v:lua.%s()
    augroup END
  ]]):format(
    update_stl_key,
    augroup_name,
    table.concat(update_events, ','),
    update_stl_key
  )

  api.nvim_exec(setup_au_cmd, false)
end

return M
