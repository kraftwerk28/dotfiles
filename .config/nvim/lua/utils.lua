local M = {}

function M.get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

function M.debounce(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
    local args = {...}

    timer_id = vim.fn.timer_start(timeout, function()
      func(args)
      timer_id = nil
    end)
  end
end

function M.throttle(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id == nil then
      func {...}
      timer_id = vim.fn.timer_start(timeout, function() timer_id = nil end)
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

function _G.replace_text(startpos, endpos, text) end

function M.load(path)
  local ok, mod = pcall(require, path)
  if not ok then print(string.format('Module %s doesn\'t exist', path)) end
  if ok then
    local loadfn
    if type(mod) == 'function' then
      loadfn = mod
    elseif mod.setup ~= nil then
      loadfn = mod.setup
    end
    local ok, err = pcall(loadfn)
    if not ok then print('ERROR:', err) end
  end
end

function M.hl_by_name(hl_group)
  local hl = vim.api.nvim_get_hl_by_name(hl_group, true)
  if hl.foreground ~= nil then hl.fg = string.format('#%x', hl.foreground) end
  if hl.background ~= nil then hl.bg = string.format('#%x', hl.background) end
  return hl
end

function M.highlight(hl_group, fg, bg, gui)
  local guifg = fg and ' guifg=' .. fg or ''
  local guibg = bg and ' guibg=' .. bg or ''
  local gui = gui and ' gui=' .. gui or ''
  vim.cmd('highlight ' .. hl_group .. guibg .. guifg .. gui)
end

return M
