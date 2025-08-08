local opts = {
  liststyle = 3, -- Tree-like
  netrw_localrmdir = "rm -r",
}

for k, v in pairs(opts) do
  vim.g["netrw_" .. k] = v
end

autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "o", "<CR>", { remap = true, buffer = true })
  end,
})
