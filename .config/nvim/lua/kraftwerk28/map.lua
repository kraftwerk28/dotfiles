-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "p", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd.normal { vim.v.count1 .. "p", bang = true }
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

-- Do not replace `+` register's contents when cutting text
vim.keymap.set("x", "P", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd.normal { vim.v.count1 .. "p", bang = true }
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

-- For long enough lines thats span multiple editor lines, j/k jumps to the
-- next *editor* line instead of *text* line
for _, ch in ipairs { "j", "k" } do
  vim.keymap.set("n", ch, function()
    if vim.v.count1 > 1 then
      return ch
    end
    return "g" .. ch
  end, { expr = true })
  vim.keymap.set("n", "g" .. ch, ch)
end

-- Arrow mappings (why?)
vim.keymap.set("n", "<Down>", "<C-E>")
vim.keymap.set("n", "<Up>", "<C-Y>")
vim.keymap.set("n", "<S-Up>", "<C-U>M")
vim.keymap.set("n", "<S-Down>", "<C-D>M")
vim.keymap.set("n", "<C-Up>", "<C-B>M")
vim.keymap.set("n", "<C-Down>", "<C-F>M")

-- Do not reset selection after shifting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Buffer navigation
vim.keymap.set("n", "<M-]>", "<Cmd>bnext<CR>", { silent = true })
vim.keymap.set("n", "<M-[>", "<Cmd>bprevious<CR>", { silent = true })

-- Tab navigation
vim.keymap.set("n", "th", "<Cmd>tabprevious<CR>", { silent = true })
vim.keymap.set("n", "tj", "<Cmd>tablast<CR>", { silent = true })
vim.keymap.set("n", "tk", "<Cmd>tabfirst<CR>", { silent = true })
vim.keymap.set("n", "tl", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "tt", "<Cmd>tabnew<CR>", { silent = true })
vim.keymap.set("n", "td", "<Cmd>tabclose<CR>", { silent = true })
vim.keymap.set("n", "tH", "<Cmd>-tabmove<CR>", { silent = true })
vim.keymap.set("n", "tL", "<Cmd>+tabmove<CR>", { silent = true })
for i = 1, 9 do
  vim.keymap.set(
    "n",
    "<M-" .. i .. ">",
    "<Cmd>silent! " .. i .. "tabnext<CR>",
    { silent = true }
  )
end

-- Toggle search highlight
vim.keymap.set("n", "<Leader>hs", function()
  vim.o.hlsearch = not vim.o.hlsearch
end)

vim.keymap.set("n", "<Leader>w", "<Cmd>wall<CR>", { silent = true })

-- Move line/block across the buffer
vim.keymap.set("n", "<M-k>", ":m-2<CR>==", { silent = true })
vim.keymap.set("n", "<M-j>", ":m+1<CR>==", { silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { silent = true })

vim.keymap.set("i", "<C-BS>", "<C-W>")
vim.keymap.set("v", "/", [["vy/<C-R>v<CR>]])
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
  { "True", "False" },
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
      vim.cmd.normal { "ciw" .. rhs, bang = true }
      return
    elseif cword == rhs then
      vim.cmd.normal { "ciw" .. lhs, bang = true }
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

vim.keymap.set("n", "<Leader>/", [[/^\s*\<]], {
  desc = "Search from line start. Useful for searching for flags in manpages.",
})

-- Disable Mod-Space
vim.keymap.set("i", "<D-Space>", "<Nop>")

vim.keymap.set("n", "<Leader>dc", function()
  vim.diagnostic.open_float { border = vim.g.borderchars }
end, { desc = "[D]iagnostics under [C]ursor" })

-- Layout-agnostic mappings, i.e. for cyrrillic
local function lmap_esc(s)
  return vim.fn.escape(s, [[;,"|]])
end

local function map_ctrl_keys(lhs, rhs)
  for i = 1, vim.fn.strcharlen(lhs) do
    local map_cyr = vim.fn.strcharpart(lhs, i - 1, 1)
    local map_lat = vim.fn.strcharpart(rhs, i - 1, 1)
    vim.keymap.set(
      { "n", "i" },
      "<C-" .. map_cyr .. ">",
      "<C-" .. map_lat .. ">"
    )
  end
end

local langmap_config = {
  {
    [[йцукенгшщзфівапролдячсмить]],
    [[qwertyuiopasdfghjklzxcvbnm]],
  },
  {
    [[ЙЦУКЕНГШЩЗФІВАПРОЛДЯЧСМИТЬ]],
    [[QWERTYUIOPASDFGHJKLZXCVBNM]],
  },
  {
    [[хїґжєбю]],
    [[[]\;',.]],
  },
  {
    [[ХЇҐЖЄБЮ]],
    [[{}|:"<>]],
  },
}

vim.go.langmap = vim
  .iter(langmap_config)
  :map(function(pair)
    return lmap_esc(pair[1]) .. ";" .. lmap_esc(pair[2])
  end)
  :join(",")

map_ctrl_keys(unpack(langmap_config[1]))
map_ctrl_keys(unpack(langmap_config[3]))
