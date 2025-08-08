local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not vim.uv.fs_stat(lazypath) then
  local clone_result = vim
    .system {
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable", -- latest stable release
      lazyrepo,
      lazypath,
    }
    :wait()
  if clone_result.code ~= 0 then
    vim.notify("Failed to clone Lazy repo", vim.log.levels.ERROR)
  end
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup {
  spec = { import = "kraftwerk28.plugins.init" },
}
