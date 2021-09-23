local o = vim.opt

o.hidden = true
o.expandtab = false
o.softtabstop = 0
o.tabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.smartindent = true
o.list = true
o.listchars = {tab = "» ", trail = "·"}
-- o.listchars = {tab = "⇥ ", trail = "·"}
o.cursorline = false
o.colorcolumn = {80, 120}
o.mouse = "a"
o.clipboard = "unnamedplus"
o.completeopt = {"menu", "menuone", "noselect"}
o.incsearch = true
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.wildmenu = true
o.wildmode = "full"
o.signcolumn = "yes"
o.autoread = true
o.autowrite = true
o.autowriteall = true
o.foldlevel = 99
o.foldmethod = "indent"
o.foldopen = {"hor", "mark", "percent", "quickfix", "search", "tag", "undo"}
o.exrc = true
o.secure = true

-- Vertical insert / cmdline-insert:
-- o.guicursor = "n-sm-c:block,i-ci:ver25,r-cr-o-v:hor20"
-- o.guicursor = "n-sm-c-i-ci:block,r-cr-o-v:hor20"
o.guicursor = "n-c-sm:block,i-ci:ver25,r-cr-o-v:hor20,a:blinkon1"

-- guicursor = {
--   ["n-sm-c"] = "block",
--   ["i-ci"] = "ver25",
--   ["r-cr-o-v"] = "hor20",
-- },
-- Block insert / cmdline-insert:

-- guicursor = "n-sm-c:block,r-cr-o-v:hor20",

o.splitbelow = true
o.splitright = true
o.regexpengine = 0
o.lazyredraw = true
o.showmode = false
o.undofile = true
o.backupcopy = "yes"
o.inccommand = "nosplit"
o.title = true

o.shortmess:append("c")
o.diffopt:append("vertical")

if vim.fn.has("win64") == 1 then
  -- Obsolette after I switched to nvim-qt:
  -- o.guifont = "JetBrainsMono NF:h18"
  o.shell = "powershell.exe"
  o.shellquote = ""
  o.shellpipe = "|"
  o.shellxquote = ""
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  o.shellredir = "| Out-File -Encoding UTF8"
end
