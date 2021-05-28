local M = {}

local utils = require('utils')
local sprintf = utils.sprintf

local function get_padding(cfg)
  local lp, rp = 0, 0
  if cfg.padding ~= nil then
    return cfg.padding, cfg.padding
  end
  if cfg.padl ~= nil then
    lp = cfg.padl
  end
  if cfg.padr ~= nil then
    rp = cfg.padr
  end
  if cfg.padding ~= nil then
    lp = cfg.padding
    rp = cfg.padding
  end
  return lp, rp
end

local on_update_handlers = {}

function M.component_builder()
  local get_id = utils.id_generator()

  return function(config)
    local result = ''
    local padl, padr = 0, 0
    if type(config.padding) == 'table' and #config.padding >= 2 then
      padl, padr = unpack(config.padding)
    elseif type(config.padding) == 'number' then
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
      local name = '_stl_cfn' .. get_id()
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
      local fn_name = "_stl_fn" .. get_id()
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
      error("config[1] (config.render) must be function or string")
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

    if type(config.on_update) == "function" then
      table.insert(on_update_handlers, config.on_update)
    end

    return result
  end
end

function M.on_update()
  for _, fn in on_update_handlers do
    fn()
  end
end

function M.combine_components(...) return table.concat {...} end

M.make_component = M.component_builder()

return M
