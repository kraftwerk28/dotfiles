local api, fn = vim.api, vim.fn

m("x", "p", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  fn.setreg("+", fn.getreg("a"))
end)

m("x", "P", function()
  fn.setreg("a", fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  fn.setreg("+", fn.getreg("a"))
end)

api.nvim_create_autocmd("TextYankPost", {
  pattern = "svg,xml,html",
  callback = function()
    m("i", "</>", "</<C-X><C-O><C-N>", { buffer = true })
  end,
  group = api.nvim_create_augroup("tag_completion", {}),
})

m("n", "j", function()
  return vim.v.count1 > 1 and "j" or "gj"
end, { expr = true })

m("n", "k", function()
  return vim.v.count1 > 1 and "k" or "gk"
end, { expr = true })

m("n", "<Down>", "<C-E>")
m("n", "<Up>", "<C-Y>")
m("n", "<S-Up>", "<C-U>M")
m("n", "<S-Down>", "<C-D>M")
m("n", "<C-Up>", "<C-B>M")
m("n", "<C-Down>", "<C-F>M")

m("v", ">", ">gv")
m("v", "<", "<gv")

-- Buffer navigation
m("n", "<M-]>", "<Cmd>bnext<CR>")
m("n", "<M-[>", "<Cmd>bprevious<CR>")

-- Tab navigation
m("n", "th", "<Cmd>tabprevious<CR>")
m("n", "tj", "<Cmd>tablast<CR>")
m("n", "tk", "<Cmd>tabfirst<CR>")
m("n", "tl", "<Cmd>tabnext<CR>")
m("n", "tt", "<Cmd>tabnew<CR>")
m("n", "td", "<Cmd>tabclose<CR>")
m("n", "tH", "<Cmd>-tabmove<CR>")
m("n", "tL", "<Cmd>+tabmove<CR>")

for i = 1, 9 do
  m("n", ("<M-%d>"):format(i), ("<Cmd>%dtabnext<CR>"):format(i))
end

m("n", "<Leader>hs", function()
  vim.opt_local.hlsearch = not vim.opt_local.hlsearch:get()
end)
m("n", "<Leader>w", "<Cmd>wall<CR>")

m("n", "<M-k>", "<Cmd>m-2<CR>")
m("n", "<M-j>", "<Cmd>m+1<CR>")
m("v", "<M-k>", "<Cmd>m'<-2<CR>gv")
m("v", "<M-j>", "<Cmd>m'>+1<CR>gv")

m("i", "<C-BS>", "<C-W>")

m("v", "/", [["vy/<C-R>v<CR>]])

m("n", "<Leader>ma", ":<C-U>vertical Man ")

m("n", "H", "<Nop>")

m("n", "dbo", "<Cmd>%bd<CR><C-O>")
m("n", "dba", "<Cmd>%bd<CR>")
m("n", "dbb", "<C-W>s<Cmd>bd<CR>")
