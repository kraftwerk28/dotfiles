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

require("base16-colorscheme").with_config({
  telescope = false,
})

-- vim.cmd.colorscheme("base16-gruvbox-dark-medium")
-- vim.cmd.colorscheme("base16-gruvbox-light-medium")
vim.cmd.colorscheme("base16-eighties")

-- vim.cmd.colorscheme("github_dark_default")
-- vim.cmd.colorscheme("kanagawa")
-- vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("gruvbox")
