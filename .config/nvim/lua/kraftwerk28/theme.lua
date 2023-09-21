vim.o.background = "dark"

require("github-theme").setup({
  options = {
    hide_nc_statusline = false,
  },
  groups = {
    all = {
      StatusLine = { link = "ColorColumn" },
    },
  },
})

-- require("onedark").setup({
--   style = "warmer",
--   ending_tildes = true,
-- })

-- require("ayu").setup({
--   mirage = true,
-- })

-- require("base16-colorscheme").with_config({
--   telescope = false,
-- })

-- require("gruvbox").setup({
--   contrast = "soft", -- can be "hard", "soft" or empty string
-- })

-- require("gruvbox").setup({
--   overrides = {
--     Cursor = { reverse = true },
--   },
-- })

-- vim.cmd.colorscheme("base16-gruvbox-dark-medium")
-- vim.cmd.colorscheme("base16-gruvbox-light-medium")
-- vim.cmd.colorscheme("base16-eighties")
vim.cmd.colorscheme("github_dark")
-- vim.cmd.colorscheme("kanagawa-dragon")
-- vim.cmd.colorscheme("kanagawa-lotus")
-- vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("gruvbox")
-- vim.cmd.colorscheme("ayu")
