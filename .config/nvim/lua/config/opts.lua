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
o.cursorline = true
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
-- o.foldexpr = "nvim_treesitter#foldexpr()"
-- o.foldmethod = "expr"
o.foldopen = {"hor", "mark", "percent", "quickfix", "search", "tag", "undo"}
o.exrc = true
o.secure = true

-- default 'guicursor':
-- o.guicursor = {"n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20"}

-- o.guicursor = {"a:blinkon1"}
o.guicursor = {
  "a:blinkon1",
  "n-sm:block",
  "i-c-ci-ve:ver25",
  "r-cr-o-v:hor50",
}

o.splitbelow = true
o.splitright = true
o.regexpengine = 0
o.lazyredraw = true
o.showmode = false
o.undofile = true
o.backupcopy = "yes"
o.inccommand = "nosplit"
o.title = true

-- o.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

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
