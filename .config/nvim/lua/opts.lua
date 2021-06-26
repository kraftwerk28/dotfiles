vim.g.mapleader = " "

local opts = {
  hidden = true,
  expandtab = false,
  softtabstop = 0,
  tabstop = 4,
  shiftwidth=4,
  autoindent = true,
  smartindent = true,
  list = true,
  listchars = {tab = "⇥ ", trail = "·"},
  cursorline = true,
  colorcolumn={80, 120},
  mouse= "a",
  clipboard = "unnamedplus",
  completeopt={"menu", "menuone", "noselect"},
  incsearch = true,
  hlsearch = false,
  ignorecase = true,
  smartcase = true,
  wildmenu = true,
  wildmode = "full",
  signcolumn = "yes",
  autoread = true,
  autowrite = true,
  autowriteall = true,
  foldlevel = 99,
  foldmethod = "indent",
  foldopen = {"hor", "mark", "percent", "quickfix", "search", "tag", "undo"},
  exrc = true,
  secure = true,
  scrolloff = 3,

  -- Vertical insert / cmdline-insert:
  -- guicursor = "n-sm-c:block,i-ci:ver25,r-cr-o-v:hor20",

  -- guicursor = {
  --   ["n-sm-c"] = "block",
  --   ["i-ci"] = "ver25",
  --   ["r-cr-o-v"] = "hor20",
  -- },
  -- Block insert / cmdline-insert:
  guicursor = "n-sm-c:block,r-cr-o-v:hor20",

  splitbelow = true,
  splitright = true,
  regexpengine = 0,
  lazyredraw = true,
  guifont = "JetBrains Mono Nerd Font:h12",
  showmode = false,
  undofile = true,
  backupcopy = "yes",
  inccommand = "nosplit",
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.opt.diffopt:append("vertical")