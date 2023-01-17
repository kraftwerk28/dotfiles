-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "p", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  vim.fn.setreg("+", vim.fn.getreg("a"))
end)

-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "P", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  vim.fn.setreg("+", vim.fn.getreg("a"))
end)

autocmd("TextYankPost", {
  pattern = "svg,xml,html",
  callback = function()
    vim.keymap.set("i", "</>", "</<C-X><C-O><C-N>", { buffer = true })
  end,
  group = augroup("tag_completion", {}),
})

vim.keymap.set("n", "j", function()
  return vim.v.count1 > 1 and "j" or "gj"
end, { expr = true })

vim.keymap.set("n", "k", function()
  return vim.v.count1 > 1 and "k" or "gk"
end, { expr = true })

vim.keymap.set("n", "<Down>", "<C-E>")
vim.keymap.set("n", "<Up>", "<C-Y>")
vim.keymap.set("n", "<S-Up>", "<C-U>M")
vim.keymap.set("n", "<S-Down>", "<C-D>M")
vim.keymap.set("n", "<C-Up>", "<C-B>M")
vim.keymap.set("n", "<C-Down>", "<C-F>M")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

local silent = { silent = true }

-- Buffer navigation
vim.keymap.set("n", "<M-]>", "<Cmd>bnext<CR>", silent)
vim.keymap.set("n", "<M-[>", "<Cmd>bprevious<CR>", silent)

-- Tab navigation
vim.keymap.set("n", "th", "<Cmd>tabprevious<CR>", silent)
vim.keymap.set("n", "tj", "<Cmd>tablast<CR>", silent)
vim.keymap.set("n", "tk", "<Cmd>tabfirst<CR>", silent)
vim.keymap.set("n", "tl", "<Cmd>tabnext<CR>", silent)
vim.keymap.set("n", "tt", "<Cmd>tabnew<CR>", silent)
vim.keymap.set("n", "td", "<Cmd>tabclose<CR>", silent)
vim.keymap.set("n", "tH", "<Cmd>-tabmove<CR>", silent)
vim.keymap.set("n", "tL", "<Cmd>+tabmove<CR>", silent)

for i = 1, 9 do
  local lhs = ("<M-%d>"):format(i)
  local rhs = ("<Cmd>%dtabnext<CR>"):format(i)
  vim.keymap.set("n", lhs, rhs, silent)
end

vim.keymap.set("n", "<Leader>hs", function()
  vim.opt_local.hlsearch = not vim.opt_local.hlsearch:get()
end)

vim.keymap.set("n", "<Leader>w", "<Cmd>wall<CR>", silent)

vim.keymap.set("n", "<M-k>", "<Cmd>m-2<CR>", silent)
vim.keymap.set("n", "<M-j>", "<Cmd>m+1<CR>", silent)
vim.keymap.set("v", "<M-k>", ":m'<-2<CR>gv", silent)
vim.keymap.set("v", "<M-j>", ":m'>+1<CR>gv", silent)

vim.keymap.set("i", "<C-BS>", "<C-W>")
vim.keymap.set("v", "/", [["vy/<C-R>v<CR>]])
vim.keymap.set("n", "<Leader>ma", ":<C-U>vertical Man ")
vim.keymap.set("n", "H", "<Nop>")
vim.keymap.set("n", "dbo", "<Cmd>%bd<CR><C-O>")
vim.keymap.set("n", "dba", "<Cmd>%bd<CR>")
vim.keymap.set("n", "dbb", "<C-W>s<Cmd>bd<CR>")

-- Remap annoying K to <Leader>K
vim.keymap.set("n", "<Leader>K", "K")
vim.keymap.set("n", "K", "<Nop>")

-- Toggle common boolean-like values
local boolean_map = {
  ["true"] = "false",
  ["True"] = "False",
  ["1"] = "0",
  ["yes"] = "no",
  ["Yes"] = "No",
}
vim.keymap.set("n", "<Leader>t", function()
  local cword = vim.fn.expand("<cword>")
  for lhs, rhs in pairs(boolean_map) do
    if cword == lhs then
      return "ciw" .. rhs .. "<Esc>"
    elseif cword == rhs then
      return "ciw" .. lhs .. "<Esc>"
    end
  end
end, { expr = true })
