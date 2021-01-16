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
    print('Formatted using \'formatprg\': `' .. formatprg .. '`')
    return true
  else
    return false
  end
end

return M
