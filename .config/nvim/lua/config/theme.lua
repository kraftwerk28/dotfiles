local utils = require("config.utils")

vim.o.background = "dark"
vim.g.base16_theme = vim.env.BASE16_THEME or "default-dark"

local ok, base16 = pcall(require, "base16-colorscheme")

local function set_base16_theme(name)
  local colors = vim.deepcopy(base16.colorschemes[name])
  -- colors.base08 = colors.base06
  base16.setup(colors)
end

if not ok then
  print("base16-colorscheme is not installed")
else
  set_base16_theme(vim.g.base16_theme)
end

-- vim.g.ayucolor = "mirage"
-- vim.g.onedark_style = "darker"
-- vim.cmd("colorscheme onedark")

-- TODO: doesn't work anymore
-- https://github.com/RRethy/nvim-base16/blob/master/lua/base16-colorscheme.lua#L325-L331
-- utils.nnoremap(
--   "<F6>",
--   function ()
--     local names = vim.tbl_keys(base16.colorschemes)
--     local nameidx = utils.index_of(names, vim.g.base16_theme)
--     nameidx = nameidx - 1
--     if nameidx < 1 then nameidx = #names end
--     local name = names[nameidx]
--     vim.g.base16_theme = name
--     print(("(%d/%d) %s"):format(nameidx, #names, name))
--     set_base16_theme(name)
--     utils.load("config.statusline")
--   end,
--   {silent = true}
-- )

-- utils.nnoremap(
--   "<F7>",
--   function()
--     local names = vim.tbl_keys(base16.colorschemes)
--     local nameidx = utils.index_of(names, vim.g.base16_theme)
--     nameidx = nameidx + 1
--     if nameidx > #names then nameidx = 1 end
--     local name = names[nameidx]
--     vim.g.base16_theme = name
--     print(("(%d/%d) %s"):format(nameidx, #names, name))
--     set_base16_theme(name)
--     base16.setup(name)
--     utils.load("config.statusline")
--   end,
--   {silent = true}
-- )
