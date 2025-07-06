autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.porth",
  callback = function()
    setlocal.filetype = "porth"
  end,
})
