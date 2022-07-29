_G.m = function(...)
  vim.keymap.set(...)
end

_G.o = vim.opt
_G.lo = vim.opt_local
_G.go = vim.opt_global

_G.A = setmetatable({}, {
  __index = function(_, k)
    return vim.api["nvim_" .. k]
  end,
})

_G.au = function(...)
  return vim.api.nvim_create_autocmd(...)
end

_G.aug = function(name, opts)
  opts = opts or {}
  return vim.api.nvim_create_augroup(name, opts)
end
