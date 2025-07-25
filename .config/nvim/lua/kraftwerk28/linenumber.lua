-- Show relative line number in the current window.
-- Show absolute line number for the rest.

local no_line_number_ft = { "help", "man", "list", "TelescopePrompt" }

local number_augroup = augroup("number")

autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
  callback = function()
    if
      vim.fn.win_gettype() ~= ""
      or vim.tbl_contains(no_line_number_ft, vim.bo.filetype)
    then
      return
    end
    vim.o.number = true
    vim.o.relativenumber = true
  end,
  group = number_augroup,
})

autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  callback = function()
    if
      vim.fn.win_gettype() ~= ""
      or vim.tbl_contains(no_line_number_ft, vim.bo.filetype)
    then
      return
    end
    vim.o.number = true
    vim.o.relativenumber = false
  end,
  group = number_augroup,
})
