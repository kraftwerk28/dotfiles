local map = vim.keymap.set

-- Do not replace `+` register's contents when cutting text
map("x", "p", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd.normal { vim.v.count1 .. "p", bang = true }
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

-- Do not replace `+` register's contents when cutting text
map("x", "P", function()
  vim.fn.setreg("a", vim.fn.getreg("+"))
  vim.cmd.normal { vim.v.count1 .. "p", bang = true }
  vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Paste, but don't pollute `+` register" })

-- For long enough lines thats span multiple editor lines, j/k jumps to the
-- next *editor* line instead of *text* line
for _, ch in ipairs { "j", "k" } do
  map("n", ch, function()
    if vim.v.count1 > 1 then
      return ch
    end
    return "g" .. ch
  end, { expr = true })
  map("n", "g" .. ch, ch)
end

-- Arrow mappings (why?)
map("n", "<Down>", "<C-E>")
map("n", "<Up>", "<C-Y>")
map("n", "<S-Up>", "<C-U>M")
map("n", "<S-Down>", "<C-D>M")
map("n", "<C-Up>", "<C-B>M")
map("n", "<C-Down>", "<C-F>M")

-- Do not reset selection after shifting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Buffer navigation
map("n", "<M-]>", "<Cmd>bnext<CR>", { silent = true })
map("n", "<M-[>", "<Cmd>bprevious<CR>", { silent = true })

-- Tab navigation
map("n", "th", "<Cmd>tabprevious<CR>", { silent = true })
map("n", "tj", "<Cmd>tablast<CR>", { silent = true })
map("n", "tk", "<Cmd>tabfirst<CR>", { silent = true })
map("n", "tl", "<Cmd>tabnext<CR>", { silent = true })
map("n", "tt", "<Cmd>tabnew<CR>", { silent = true })
map("n", "td", "<Cmd>tabclose<CR>", { silent = true })
map("n", "tH", "<Cmd>-tabmove<CR>", { silent = true })
map("n", "tL", "<Cmd>+tabmove<CR>", { silent = true })
for i = 1, 9 do
  map(
    "n",
    "<M-" .. i .. ">",
    "<Cmd>silent! " .. i .. "tabnext<CR>",
    { silent = true }
  )
end

-- Toggle search highlight
map("n", "<Leader>hs", function()
  vim.o.hlsearch = not vim.o.hlsearch
end)

map("n", "<Leader>w", "<Cmd>wall<CR>", { silent = true })

-- Move line/block across the buffer
map("n", "<M-k>", ":m-2<CR>==", { silent = true })
map("n", "<M-j>", ":m+1<CR>==", { silent = true })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { silent = true })
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { silent = true })

map("i", "<C-BS>", "<C-W>")
map("v", "/", [["vy/<C-R>v<CR>]])
map("n", "H", "<Nop>")
map("n", "dbo", "<Cmd>%bd<CR><C-O>")
map("n", "dba", "<Cmd>%bd<CR>")
map("n", "dbb", "<C-W>s<Cmd>bd<CR>")

-- Remap annoying K to <Leader>K
-- map("n", "<Leader>K", "K")
map("n", "K", "<Nop>")

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

map("n", "<Leader>t", function()
  local wininfo = vim.fn.winsaveview()

  -- Try find word from `boolean_map`
  local cword = vim.fn.expand("<cword>")
  local changeword
  for _, pair in ipairs(boolean_map) do
    if cword == pair[1] then
      changeword = pair[2]
      break
    elseif cword == pair[2] then
      changeword = pair[1]
      break
    end
  end
  if changeword then
    vim.cmd.normal { "ciw" .. changeword, bang = true }
    vim.fn.winrestview(wininfo)
    return
  end

  -- Try to toggle markdown checkmark
  local line = vim.api.nvim_get_current_line()
  local md_check_start, md_check_end = line:find("%[ %]")
  if md_check_start then
    local new_line = line:sub(1, md_check_start - 1)
      .. "[x]"
      .. line:sub(md_check_end + 1)
    vim.api.nvim_set_current_line(new_line)
    vim.fn.winrestview(wininfo)
    return
  end
  md_check_start, md_check_end = line:find("%[x%]")
  if md_check_start then
    local new_line = line:sub(1, md_check_start - 1)
      .. "[ ]"
      .. line:sub(md_check_end + 1)
    vim.api.nvim_set_current_line(new_line)
    vim.fn.winrestview(wininfo)
    return
  end
end, { desc = "Toggle common boolean literals" })

-- Quickfix
map("n", "<Leader>qj", "<Cmd>cnext<CR>")
map("n", "<Leader>qk", "<Cmd>cprev<CR>")

map("n", "<Leader>/", [[/^\s*\<]], {
  desc = "Search from line start. Useful for searching for flags in manpages.",
})

-- Disable Mod-Space
map("i", "<D-Space>", "<Nop>")

map("n", "<Leader>dc", function()
  vim.diagnostic.open_float()
end, { desc = "[D]iagnostics under [C]ursor" })

-- Layout-agnostic mappings, i.e. for cyrrillic
local function lmap_esc(s)
  return vim.fn.escape(s, [[;,"|]])
end

local function map_ctrl_keys(lhs, rhs)
  for i = 1, vim.fn.strcharlen(lhs) do
    local map_cyr = vim.fn.strcharpart(lhs, i - 1, 1)
    local map_lat = vim.fn.strcharpart(rhs, i - 1, 1)
    map({ "n", "i" }, "<C-" .. map_cyr .. ">", "<C-" .. map_lat .. ">")
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
