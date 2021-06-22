local M = {}

function M.patch_lsp_handlers()
  local emitter = {_handlers = {}}

  function emitter:on(method, handler)
    self[method] = handler
  end

  function emitter:once(method, handler)
    local function handle_once(...)
      handler(...)
      self:off(method, handle_once)
    end
    self:on(method, handle_once)
  end

  function emitter:off(method, handler)
    local handlers = self._handlers
    if handlers[method] == nil then return end
    if handler == nil then
      handlers[method] = nil
      return
    end
    for k, v in pairs(handlers[method]) do
      if v == handler then
        handlers[method][k] = nil
        return
      end
    end
  end

  function emitter:emit(method, ...)
    local handler = self[method]
    if handler ~= nil then handler(...) end
  end

  function emitter:getlisteners(method)
    return self._handlers[method] or {}
  end

  function emitter:replace_all(method, handler)
    self._handlers[method] = {handler}
  end

  local emitter_mt = {}
  function emitter_mt:__index(method)
      local handlers = self._handlers
      if handlers[method] == nil then return nil end
      if #handlers[method] == 1 then return handlers[method][1] end
      return function(...)
        for _, handler in ipairs(handlers[method]) do
          handler(...)
        end
      end
  end
  function emitter_mt:__newindex(method, handler)
    local handlers = self._handlers
    if handlers[method] == nil then handlers[method] = {} end
    if handler == nil then
      -- Clear handlers for this method
      handlers[method] = {}
      return
    end
    if vim.tbl_contains(handlers[method], handler) then
      -- Skip adding multiple same handlers
      return
    end
    table.insert(handlers[method], handler)
  end

  setmetatable(emitter, emitter_mt)

  -- Move stock handlers to event emitter
  for method, handler in pairs(vim.lsp.handlers) do
    emitter:on(method, handler)
    vim.lsp.handlers[method] = nil
  end

  setmetatable(vim.lsp.handlers, {__index = emitter, __newindex = emitter})
end

return M
