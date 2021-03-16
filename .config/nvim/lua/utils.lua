local M = {}

local function printf(...) print(string.format(...)) end
local sprintf = string.format

M.printf = printf
M.sprintf = sprintf

function M.get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

function M.debounce(func, timeout)
  local timer_id
  return function(...)
    if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
    local args = {...}
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
    local args = {...}
    if timer_id == nil then
      func(args)
      local function cb()
        timer_id = nil
        if did_call then
          func(args)
          did_call = false
        end
      end
      timer_id = vim.fn.timer_start(timeout, cb)
    else
      did_call = true
    end
  end
end

function M.format_formatprg()
  local opt_exists, formatprg = pcall(function() return vim.bo.formatprg end)
  if opt_exists and #formatprg > 0 then
    local view = vim.fn.winsaveview()
    vim.api.nvim_command('normal gggqG')
    vim.fn.winrestview(view)
    return true
  else
    return false
  end
end

-- Convert UTF-8 hex code to character
function M.u(code)
  if type(code) == 'string' then code = tonumber('0x' .. code) end
  local c = string.char
  if code <= 0x7f then return c(code) end
  local t = {}
  if code <= 0x07ff then
    t[1] = c(bit.bor(0xc0, bit.rshift(code, 6)))
    t[2] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  elseif code <= 0xffff then
    t[1] = c(bit.bor(0xe0, bit.rshift(code, 12)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  else
    t[1] = c(bit.bor(0xf0, bit.rshift(code, 18)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[4] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  end
  return table.concat(t)
end

function _G.dump(...)
  local args = {...}
  if #args == 1 then
    print(vim.inspect(args[1]))
  else
    print(vim.inspect(args))
  end
end

function M.load(path)
  local ok, mod = pcall(require, path)
  if not ok then
    printf('Error loading module `%s`', path)
    print(mod)
  else
    local loadfunc
    if type(mod) == 'function' then
      loadfunc = mod
    elseif mod.setup ~= nil then
      loadfunc = mod.setup
    end
    local ok, err = pcall(loadfunc)
    if not ok then
      printf('Error loading module `%s`', path)
      print(err)
    end
  end
end

-- Get information about highlight group
function M.hl_by_name(hl_group)
  local hl = vim.api.nvim_get_hl_by_name(hl_group, true)
  if hl.foreground ~= nil then hl.fg = string.format('#%x', hl.foreground) end
  if hl.background ~= nil then hl.bg = string.format('#%x', hl.background) end
  return hl
end

-- Define a new highlight group
-- TODO: rewrite to `nvim_set_hl()` when API will be stable
function M.highlight(cfg)
  local fg, bg = cfg.fg or cfg[2], cfg.bg or cfg[3]
  local _gui, _guisp = cfg.gui or cfg[4], cfg.guisp or cfg[5]
  local guifg = fg and ' guifg=' .. fg or ''
  local guibg = bg and ' guibg=' .. bg or ''
  local gui = _gui and ' gui=' .. _gui or ''
  local guisp = _guisp and ' guisp=' .. _guisp or ''
  vim.cmd('highlight ' .. cfg[1] .. guifg .. guibg .. gui .. guisp)
end

-- function M.highlight(hl_group, fg, bg, gui)
--   local guifg = fg and ' guifg=' .. fg or ''
--   local guibg = bg and ' guibg=' .. bg or ''
--   local gui = gui and ' gui=' .. gui or ''
--   vim.cmd('highlight ' .. hl_group .. guibg .. guifg .. gui)
-- end

return M
