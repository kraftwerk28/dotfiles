local fn = vim.fn

vim.keymap.set("n", "<Leader>ma", function()
  require("telescope.builtin").man_pages {
    sections = {"ALL"}
  }
end)

vim.keymap.set("n", "<Leader>he", function()
  require("telescope.builtin").help_tags()
end)

vim.keymap.set("x", "p", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! "..vim.v.count1.."p")
  fn.setreg("+", fn.getreg("a"))
end)

vim.keymap.set("x", "P", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! "..vim.v.count1.."p")
  fn.setreg("+", fn.getreg("a"))
end)
