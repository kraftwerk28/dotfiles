local opts = {
  liststyle = 3, -- Tree-like
  netrw_localrmdir = "rm -r",
}

for k, v in pairs(opts) do
  vim.g["netrw_" .. k] = v
end

au("FileType", {
  pattern = "netrw",
  callback = function()
    m("n", "o", "<CR>", { remap = true, buffer = true })
  end,
})
