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
  level = level or vim.log.levels.INFO
  local urgency = levelmap[level] or "normal"
  local cmd = ([[notify-send -i nvim -u %s "%s"]]):format(urgency, msg)
  vim.fn.system(cmd)
end
