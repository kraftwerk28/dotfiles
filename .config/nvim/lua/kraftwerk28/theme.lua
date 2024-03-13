vim.o.background = "dark"

-- require("github-theme").setup({
--   options = {
--     hide_nc_statusline = false,
--   },
--   groups = {
--     all = {
--       StatusLine = { link = "ColorColumn" },
--     },
--   },
-- })
-- vim.cmd.colorscheme("github_dark")

-- require("onedark").setup({
--   style = "warmer",
--   ending_tildes = true,
-- })
-- vim.cmd.colorscheme("onedark")

-- require("ayu").setup({
--   mirage = true,
-- })
-- vim.cmd.colorscheme("ayu")

-- require("base16-colorscheme").with_config({
--   telescope = false,
-- })
-- vim.cmd.colorscheme("base16-gruvbox-dark-medium")
-- vim.cmd.colorscheme("base16-gruvbox-light-medium")
-- vim.cmd.colorscheme("base16-eighties")

require("gruvbox").setup({
  contrast = "hard", -- can be "hard", "soft" or empty string
  italic = {
    strings = false,
    comments = false,
  },
})
vim.cmd.colorscheme("gruvbox")

-- vim.cmd.colorscheme("kanagawa")
