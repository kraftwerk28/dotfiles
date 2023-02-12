local no_line_number_ft = { "help", "man", "list", "TelescopePrompt" }

local number_augroup = augroup("number")

autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
  -- callback = set_nu(true),
  callback = function()
    if
      vim.fn.win_gettype() ~= ""
      or vim.tbl_contains(no_line_number_ft, vim.bo.filetype)
    then
      return
    end
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
  group = number_augroup,
})

autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  -- callback = set_nu(false),
  callback = function()
    if
      vim.fn.win_gettype() ~= ""
      or vim.tbl_contains(no_line_number_ft, vim.bo.filetype)
    then
      return
    end
    vim.wo.number = true
    vim.wo.relativenumber = false
  end,
  group = number_augroup,
})
