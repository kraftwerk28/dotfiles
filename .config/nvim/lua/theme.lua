local utils = require("utils")

local ok, base16 = pcall(require, "base16-colorscheme")
if not ok then print("base16-colorscheme is not installed") end
-- if ok then base16.setup(vim.g.base16_theme) end

local function set_theme(name)
  vim.cmd("colorscheme base16-"..name)
end

set_theme(vim.g.base16_theme)

utils.nnoremap(
  "<F6>",
  function ()
    local names = vim.tbl_keys(base16.colorschemes)
    local nameidx = utils.index_of(names, vim.g.base16_theme)
    nameidx = nameidx - 1
    if nameidx < 1 then nameidx = #names end
    local name = names[nameidx]
    vim.g.base16_theme = name
    print(("(%d/%d) %s"):format(nameidx, #names, name))
    set_theme(name)
    utils.load("statusline")
  end,
  {silent = true}
)

utils.nnoremap(
  "<F7>",
  function()
    local names = vim.tbl_keys(base16.colorschemes)
    local nameidx = utils.index_of(names, vim.g.base16_theme)
    nameidx = nameidx + 1
    if nameidx > #names then nameidx = 1 end
    local name = names[nameidx]
    vim.g.base16_theme = name
    print(("(%d/%d) %s"):format(nameidx, #names, name))
    set_theme(name)
    base16.setup(name)
    utils.load("statusline")
  end,
  {silent = true}
)
