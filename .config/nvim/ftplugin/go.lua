vim.api.nvim_create_user_command("GoChangeScope", function()
  local word = vim.fn.expand("<cword>")
  local fst = word:sub(1, 1)
  if fst:match("[A-Z]") then
    word = fst:lower() .. word:sub(2)
  else
    word = fst:upper() .. word:sub(2)
  end
  vim.lsp.buf.rename(word)
end, {})
