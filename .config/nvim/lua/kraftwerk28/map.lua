-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "p", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "P", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd("normal! " .. vim.v.count1 .. "p")
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

vim.keymap.set("n", "j", function()
  if vim.v.count1 > 1 then
    return "j"
  end
  return "gj"
end, { expr = true })

vim.keymap.set("n", "k", function()
  if vim.v.count1 > 1 then
    return "k"
  end
  return "gk"
end, { expr = true })

vim.keymap.set("n", "gj", "j")
vim.keymap.set("n", "gk", "k")

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
  local lhs = "<M-" .. i .. ">"
  local rhs = "<Cmd>silent! " .. i .. "tabnext<CR>"
  vim.keymap.set("n", lhs, rhs, silent)
end

vim.keymap.set("n", "<Leader>hs", function()
  vim.o.hlsearch = not vim.o.hlsearch
end)

vim.keymap.set("n", "<Leader>w", "<Cmd>silent! wall<CR>", silent)

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
-- vim.keymap.set("n", "<Leader>K", "K")
vim.keymap.set("n", "K", "<Nop>")

-- Toggle common boolean-like values
local boolean_map = {
  { "true", "false" },
  { "1", "0" },
  { "yes", "no" },
  { "Yes", "No" },
  { "On", "Off" },
  { "on", "off" },
  { "disable", "enable" },
  { "DISABLE", "ENABLE" },
}

vim.keymap.set("n", "<Leader>t", function()
  -- Try to toggle word from above `boolean_map`
  local cword = vim.fn.expand("<cword>")
  for _, pair in ipairs(boolean_map) do
    local lhs, rhs = pair[1], pair[2]
    if cword == lhs then
      vim.cmd("normal! ciw" .. rhs)
      return
    elseif cword == rhs then
      vim.cmd("normal! ciw" .. lhs)
      return
    end
  end

  -- Try to toggle markdown checkmark
  local line = vim.api.nvim_get_current_line()
  local md_check_start, md_check_end = line:find("%[ %]")
  if md_check_start then
    local new_line = line:sub(1, md_check_start - 1)
      .. "[x]"
      .. line:sub(md_check_end + 1)
    vim.api.nvim_set_current_line(new_line)
    return
  end
  md_check_start, md_check_end = line:find("%[x%]")
  if md_check_start then
    local new_line = line:sub(1, md_check_start - 1)
      .. "[ ]"
      .. line:sub(md_check_end + 1)
    vim.api.nvim_set_current_line(new_line)
    return
  end
end, { desc = "Toggle common boolean literals" })

-- Quickfix
vim.keymap.set("n", "<Leader>qj", "<Cmd>cnext<CR>")
vim.keymap.set("n", "<Leader>qk", "<Cmd>cprev<CR>")

vim.keymap.set("n", "<Leader>/", [[/^\s*\<\><Left><Left>]], {
  desc = "Useful mapping for searching for commands (i.e. bash builtings) in manpages",
})

vim.keymap.set("i", "<D-Space>", "<Nop>")
