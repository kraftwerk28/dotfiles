_G.m = setmetatable({
  opt_stack = {},
  withopt = function(self, opts, fn)
    vim.validate({ opts = { opts, "t" }, fn = { fn, "f" } })
    table.insert(self.opt_stack, opts)
    fn()
    table.remove(self.opt_stack)
  end,
}, {
  __call = function(self, mode, lhs, rhs, opts)
    vim.validate({
      mode = { mode, { "s", "t" } },
      lhs = { lhs, "s" },
      rhs = { rhs, { "s", "f" } },
      opts = { opts, "t", true },
    })
    local merged = {}
    for _, o in ipairs(self.opt_stack) do
      merged = vim.tbl_extend("force", merged, o)
    end
    merged = vim.tbl_extend("force", merged, opts or {})
    vim.keymap.set(mode, lhs, rhs, merged)
  end,
})

_G.o = vim.opt
_G.lo = vim.opt_local
_G.go = vim.opt_global

_G.A = setmetatable({}, {
  __index = function(_, k)
    return vim.api["nvim_" .. k]
  end,
})

_G.autocmd = function(...)
  return vim.api.nvim_create_autocmd(...)
end

_G.augroup = function(name, opts)
  return vim.api.nvim_create_augroup(name, opts or {})
end
