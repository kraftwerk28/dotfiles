local group = augroup("autocommand.lua")

autocmd("VimEnter", {
  callback = function()
    if vim.fn.glob("meson.build") ~= "" then
      setlocal.makeprg = "meson compile -C build"
    elseif vim.fn.glob("go.mod") ~= "" then
      setlocal.makeprg = "go build"
    end
  end,
  desc = "set 'makeprg' for some projects",
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 1000 })
  end,
  group = group,
})

autocmd("BufReadPost", {
  callback = function()
    local pos = vim.fn.line([['"]])
    if pos > 0 and pos <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
  group = group,
  desc = "Restore cursor position",
})

autocmd("BufWinEnter", {
  callback = function()
    if setlocal.filetype:get() == "help" then
      vim.cmd("wincmd L | 82wincmd |")
    end
  end,
  group = group,
  desc = "Set fixed width for help window",
})

-- Save buffer on unfocus
autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
  group = group,
})

autocmd("FocusGained", {
  callback = function()
    vim.fn.writefile({ vim.fn.getcwd() }, "/tmp/last-cwd")
  end,
  group = group,
})

autocmd("FileType", {
  pattern = { "man", "c", "bash", "zsh", "sh" },
  callback = function()
    vim.bo.keywordprg = ":Man"
  end,
  group = group,
})

autocmd("TextYankPost", {
  pattern = "svg,xml,html",
  callback = function()
    vim.keymap.set("i", "</>", "</<C-X><C-O><C-N>", { buffer = true })
  end,
  group = group,
})

autocmd("FileType", {
  pattern = { "man", "c", "bash", "zsh", "sh", "help" },
  callback = function()
    vim.keymap.set("n", "K", "K", { buffer = true })
  end,
  group = group,
})

-- autocmd("FileType", {
--   pattern = { "c", "cpp" },
--   callback = function()
--     -- Enable nvim-treesitter's folding
--     setlocal.foldmethod = "expr"
--     setlocal.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--   end,
--   group = group,
-- })
