local fn = vim.fn

vim.keymap.set("x", "p", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  fn.setreg("+", fn.getreg("a"))
end)

vim.keymap.set("x", "P", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  fn.setreg("+", fn.getreg("a"))
end)
