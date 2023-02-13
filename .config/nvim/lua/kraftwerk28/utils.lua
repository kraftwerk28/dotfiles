local M = {}

function M.debounce(func, timeout)
  local timer_id
  return function(...)
    if timer_id ~= nil then
      vim.fn.timer_stop(timer_id)
    end
    local args = { ... }
    local function cb()
      func(args)
      timer_id = nil
    end
    timer_id = vim.fn.timer_start(timeout, cb)
  end
end

-- FIXME
function M.throttle(func, timeout)
  local timer_id
  local did_call = false
  return function(...)
    local args = { ... }
    if timer_id == nil then
      func(unpack(args))
      local function cb()
        timer_id = nil
        if did_call then
          func(unpack(args))
          did_call = false
        end
      end
      timer_id = vim.fn.timer_start(timeout, cb)
    else
      did_call = true
    end
  end
end

-- Convert UTF-8 hex code to character
function M.u(code)
  if type(code) == "string" then
    code = tonumber("0x" .. code)
  end
  local c = string.char
  if code <= 0x7f then
    return c(code)
  end
  local x, y, z, w = "", "", "", ""
  if code <= 0x07ff then
    x = c(bit.bor(0xc0, bit.rshift(code, 6)))
    y = c(bit.bor(0x80, bit.band(code, 0x3f)))
  elseif code <= 0xffff then
    x = c(bit.bor(0xe0, bit.rshift(code, 12)))
    y = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    z = c(bit.bor(0x80, bit.band(code, 0x3f)))
  else
    x = c(bit.bor(0xf0, bit.rshift(code, 18)))
    y = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
    z = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    w = c(bit.bor(0x80, bit.band(code, 0x3f)))
  end
  return x .. y .. z .. w
end

function M.load(path)
  local ok, mod = pcall(require, path)
  if not ok then
    vim.api.nvim_err_writeln("Error loadding " .. path)
    vim.api.nvim_err_writeln(mod)
    return
  end
  local loadfn
  if type(mod) == "function" then
    loadfn = mod
  elseif type(mod) == "table" and type(mod.setup) == "function" then
    loadfn = mod.setup
  else
    return
  end
  local ok, err = pcall(loadfn)
  if not ok then
    vim.api.nvim_err_writeln("Error loading module " .. path)
    vim.api.nvim_err_writeln(err)
    return
  end
end

M.defglobalfn = setmetatable({ c = 0 }, {
  __call = function(self, f)
    vim.validate({ fn = { f, "f" } })
    local name = "_globalfn_" .. self.c
    _G[name] = f
    self.c = self.c + 1
    return name
  end,
})

return M
