_G.autocmd = function(...)
  return vim.api.nvim_create_autocmd(...)
end

_G.augroup = function(name, opts)
  return vim.api.nvim_create_augroup(name, opts or {})
end
