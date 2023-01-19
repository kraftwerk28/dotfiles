local levelmap = {
  [vim.log.levels.DEBUG] = "low",
  [vim.log.levels.ERROR] = "critical",
  [vim.log.levels.INFO] = "normal",
  [vim.log.levels.TRACE] = "low",
  [vim.log.levels.WARN] = "normal",
}

vim.notify = function(msg, level)
  if level == vim.log.levels.OFF then
    return
  end
  local uv = vim.loop
  level = level or vim.log.levels.INFO
  local urgency = levelmap[level] or "normal"
  uv.spawn("notify-send", {
    args = { "-c", "neovim", "-i", "nvim", "-u", urgency, msg },
  })
end
