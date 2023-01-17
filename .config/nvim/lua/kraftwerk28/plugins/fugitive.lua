vim.keymap.set("n", "<Leader>gs", "<Cmd>vert Git<CR>")
vim.keymap.set({ "n", "v" }, "<Leader>gb", ":GBrowse!<CR>")

-- Merge conflicts
vim.keymap.set("n", "<Leader>gm", "<Cmd>Gdiffsplit!<CR>")
vim.keymap.set("n", "<Leader>gh", "<Cmd>diffget //2<CR>")
vim.keymap.set("n", "<Leader>gl", "<Cmd>diffget //3<CR>")

autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set(
      "n",
      "<Leader>gp",
      "<Cmd>Git push origin HEAD<CR>",
      { buffer = true }
    )
  end,
})
