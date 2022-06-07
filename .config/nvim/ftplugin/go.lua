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

local function organize_imports()
  -- TODO:
  local params = vim.lsp.util.make_range_params()
  -- local lnum = vim.api.nvim_win_get_cursor(opts.winnr)[1]
  -- params.context = {
  --   diagnostics = vim.lsp.diagnostic.get_line_diagnostics(opts.bufnr, lnum - 1),
  -- }
  local result, err = vim.lsp.buf_request_sync(
    0,
    "textDocument/codeAction",
    params
  )
  if err then
    print("error", err)
    return
  end
  print(vim.inspect(result))
  -- TODO
  -- for _, r in pairs(result) do
  --   for _, cmd in ipairs(r.result) do
  --     if cmd.kind == "source.organizeImports" then
  --       vim.lsp.buf.execute_command(cmd)
  --       return
  --     end
  --   end
  -- end
end
