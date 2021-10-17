-- :Neoformat will be always ran in these filetypes
-- If LSP isn't capable to do nice formatting, I place that filetype below
vim.g.force_neoformat_filetypes = {
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
  "lua",
  "python",
}

for _, ft in ipairs(vim.g.force_neoformat_filetypes) do
  vim.g['neoformat_enabled_'..ft] = {}
end

vim.g.neoformat_enabled_python = {"autopep8"}
vim.g.neoformat_try_formatprg = 1
vim.g.neoformat_run_all_formatters = 1
