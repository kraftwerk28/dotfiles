vim.o.background = "dark"
-- vim.o.background = "light"

-- require("github-theme").setup({
--   theme_style = "dark_default",
--   -- function_style = "italic",
--   -- sidebars = { "qf", "vista_kind", "terminal", "packer" },
--   colors = { hint = "orange", error = "#ff0000" },
--   hide_inactive_statusline = false,
-- })

-- require("onedark").setup({
--   style = "warmer",
--   ending_tildes = true,
-- })

-- require("ayu").setup({
--   mirage = true,
-- })

require("base16-colorscheme").with_config({
  telescope = false,
})

-- vim.cmd.colorscheme("base16-gruvbox-dark-medium")
-- vim.cmd.colorscheme("base16-gruvbox-light-medium")
vim.cmd.colorscheme("base16-eighties")

-- require("gruvbox").setup({
--   overrides = {
--     Cursor = { reverse = true },
--   },
-- })

-- vim.cmd.colorscheme("github_dark_default")
-- vim.cmd.colorscheme("kanagawa")
-- vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("gruvbox")
-- vim.cmd.colorscheme("ayu")
