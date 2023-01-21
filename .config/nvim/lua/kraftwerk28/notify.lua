local levelmap = {
  [vim.log.levels.DEBUG] = "low",
  [vim.log.levels.ERROR] = "critical",
  [vim.log.levels.INFO] = "normal",
  [vim.log.levels.TRACE] = "low",
  [vim.log.levels.WARN] = "normal",
}

local stock_notify = vim.notify

vim.notify = function(msg, level, opts)
  stock_notify(msg, level, opts)
  if level == vim.log.levels.OFF then
    return
  end
  local urgency = levelmap[level or vim.log.levels.INFO] or "normal"
  local uv = vim.loop
  uv.spawn("notify-send", {
    args = { "-c", "neovim", "-i", "nvim", "-u", urgency, msg },
  })
end
