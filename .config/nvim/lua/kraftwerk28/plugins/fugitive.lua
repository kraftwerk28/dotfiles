m:withopt({ silent = true }, function()
  m("n", "<Leader>gs", "<Cmd>vert Git<CR>")
  m({ "n", "v" }, "<Leader>gb", ":GBrowse!<CR>")
  -- Merge conflicts
  m("n", "<Leader>gm", "<Cmd>Gdiffsplit!<CR>")
  m("n", "<Leader>gh", "<Cmd>diffget //2<CR>")
  m("n", "<Leader>gl", "<Cmd>diffget //3<CR>")
end)

au("FileType", {
  pattern = "fugitive",
  callback = function()
    m("n", "<Leader>gp", "<Cmd>Git push origin HEAD<CR>", { buffer = true })
  end,
})
