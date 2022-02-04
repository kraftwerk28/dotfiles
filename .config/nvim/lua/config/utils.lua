local M = {}

local function printf(...) print(string.format(...)) end
local sprintf = string.format
local function cmdf(...) vim.cmd(sprintf(...)) end
local fn, api = vim.fn, vim.api

M.printf = printf
M.sprintf = sprintf
M.cmdf = cmdf

function M.get_cursor_pos() return {fn.line('.'), fn.col('.')} end

function M.debounce(func, timeout)
  local timer_id
  return function(...)
    if timer_id ~= nil then
      fn.timer_stop(timer_id)
    end
    local args = {...}
    local function cb()
      func(args)
      timer_id = nil
    end
    timer_id = fn.timer_start(timeout, cb)
  end
end

-- FIXME
function M.throttle(func, timeout)
  local timer_id
  local did_call = false
  return function(...)
    local args = {...}
    if timer_id == nil then
      func(unpack(args))
      local function cb()
        timer_id = nil
        if did_call then
          func(unpack(args))
          did_call = false
        end
      end
      timer_id = fn.timer_start(timeout, cb)
    else
      did_call = true
    end
  end
end

-- Convert UTF-8 hex code to character
function M.u(code)
  if type(code) == "string" then
    code = tonumber("0x" .. code)
  end
  local c = string.char
  if code <= 0x7f then
    return c(code)
  end
  local x, y, z, w = "", "", "", ""
  if code <= 0x07ff then
    x = c(bit.bor(0xc0, bit.rshift(code, 6)))
    y = c(bit.bor(0x80, bit.band(code, 0x3f)))
  elseif code <= 0xffff then
    x = c(bit.bor(0xe0, bit.rshift(code, 12)))
    y = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    z = c(bit.bor(0x80, bit.band(code, 0x3f)))
  else
    x = c(bit.bor(0xf0, bit.rshift(code, 18)))
    y = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
    z = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    w = c(bit.bor(0x80, bit.band(code, 0x3f)))
  end
  return x..y..z..w
end

function _G.dump(...)
  local args = {...}
  if #args == 1 then
    print(vim.inspect(args[1]))
  else
    print(vim.inspect(args))
  end
end

function M.load(path)
  local ok, mod = pcall(require, path)
  if not ok then
    printf('Error loading module `%s`', path)
    print(mod)
  else
    local loadfunc
    if mod == true then
      -- Module doesn't export anything
      return
    elseif type(mod) == "table" and mod.setup ~= nil then
      loadfunc = mod.setup
    elseif type(mod) == "function" then
      loadfunc = mod
    end
    local ok, err = pcall(loadfunc)
    if not ok then
      printf("Error loading module `%s`", path)
      print(err)
    end
  end
end

-- Get information about highlight group
function M.hl_by_name(hl_group)
  local hl = api.nvim_get_hl_by_name(hl_group, true)
  if hl.foreground ~= nil then
    hl.fg = sprintf('#%x', hl.foreground)
  end
  if hl.background ~= nil then
    hl.bg = sprintf('#%x', hl.background)
  end
  return hl
end

-- Define a new highlight group
-- TODO: rewrite to `nvim_set_hl()` when API will be stable
-- function M.highlight(cfg)
--   local command = "highlight"
--   if cfg.bang == true then
--     command = command .. '!'
--   end

--   if #cfg == 2 and type(cfg[1]) == 'string' and type(cfg[2]) == 'string' then
--     -- :highlight link
--     vim.cmd(command.." link "..cfg[1].." "..cfg[2])
--     return
--   end
--   local guifg = cfg.fg or cfg.guifg
--   local guibg = cfg.bg or cfg.guibg
--   local gui = cfg.gui
--   local guisp = cfg.guisp
--   if type(cfg.override) == 'string' then
--     local existing = api.nvim_get_hl_by_name(cfg.override, true)
--     if existing.foreground ~= nil then
--       guifg = sprintf('#%x', existing.foreground)
--     end
--     if existing.background ~= nil then
--       guibg = sprintf('#%x', existing.background)
--     end
--     if existing.special ~= nil then
--       guibg = sprintf('#%x', existing.background)
--     end
--     if existing.undercurl == true then
--       gui = "undercurl"
--     elseif existing.underline == true then
--       gui = "underline"
--     end
--   end
--   command = command .. ' ' .. cfg[1]
--   if guifg ~= nil then
--     command = command .. ' guifg=' .. guifg
--   end
--   if guibg ~= nil then
--     command = command .. ' guibg=' .. guibg
--   end
--   if gui ~= nil then
--     command = command .. ' gui=' .. gui
--   end
--   if guisp ~= nil then
--     command = command .. ' guisp=' .. guisp
--   end
--   vim.cmd(command)
-- end

function last_falsy(t)
  for i, v in ipairs(t) do
    if not v then
      return t[i - 1]
    end
  end
end

local hl_special_names = {
  "bold", "underline", "undercurl", "strikethrough", "reverse", "inverse",
  "italic", "standout", "nocombine",
}

function M.get_highlight(name)
  local hl = api.nvim_get_hl_by_name(name, true)
  local special = {}
  for _, spname in ipairs(hl_special_names) do
    if hl[spname] then table.insert(special, spname) end
  end
  local gui = #special > 0 and table.concat(special, ",") or nil
  return {
    guifg = hl.foreground and ("#%x"):format(hl.foreground),
    guibg = hl.background and ("#%x"):format(hl.background),
    guisp = hl.special and ("#%x"):format(hl.special),
    gui   = gui,
  }
end

function M.highlight(cfg)
  local command = "highlight"
  if cfg.bang == true then
    command = command .. '!'
  end
  local link = cfg.link or cfg[2]
  if link then
    vim.cmd(command .. " link " .. cfg[1] .. " " .. link)
    return
  end
  -- if #cfg == 2 and type(cfg[1]) == 'string' and type(cfg[2]) == 'string' then
  --   -- :highlight link
  --   vim.cmd(command.." link "..cfg[1].." "..cfg[2])
  --   return
  -- end
  local guibg, guifg, gui, guisp
  if type(cfg.override) == "string" then
    local existing = M.get_highlight(cfg.override)
    guifg = existing.guifg
    guibg = existing.guibg
    guisp = existing.guisp
    gui   = existing.gui
  end
  -- TODO: remove fg/bg
  guifg = cfg.fg or cfg.guifg or guifg
  guibg = cfg.bg or cfg.guibg or guibg
  guisp = cfg.guisp or guisp
  gui   = cfg.gui or gui
  command = command .. " " .. cfg[1]
  if guifg then
    command = command .. " guifg=" .. guifg
  end
  if guibg then
    command = command .. " guibg=" .. guibg
  end
  if gui then
    command = command .. " gui=" .. gui
  end
  if guisp then
    command = command .. " guisp=" .. guisp
  end
  vim.cmd(command)
end

local autocmd_fn_index = 0

-- WIP:
function M.autocmd(event_name, pattern, callback)
  local fn_name = 'lua_autocmd' .. autocmd_fn_index
  autocmd_fn_index = autocmd_fn_index + 1
  _G[fn_name] = callback
  cmdf('autocmd %s %s call v:lua.%s()', event_name, pattern, fn_name)
end

function M.glob_exists(path) return fn.empty(fn.glob(path)) == 0 end

do
  -- TODO: open diagnostic on hover
  -- local show_diagnostics = vim.lsp.diagnostic.show_line_diagnostics
  -- local cursor_pos = M.get_cursor_pos()
  -- local debounced = M.debounce(show_diagnostics, 300)
  M.show_lsp_diagnostics = function()
    vim.diagnostic.open_float({border = vim.g.floatwin_border})
    -- local cursor_pos2 = M.get_cursor_pos()
    -- -- TODO: doesn't work when both diagnostics and popup is shown
    -- if cursor_pos[1] ~= cursor_pos2[1] and cursor_pos[2] ~= cursor_pos2[2] then
    --   cursor_pos = cursor_pos2
    --   debounced()
    -- end
  end
end

function M.id_generator(start)
  local cnt = start or 0
  return function()
    local result = cnt
    cnt = cnt + 1
    return result
  end
end

do
  local map_func_counter = 0
  function M.map(mode, lhs, fn, opts)
    local name = 'map_func_' .. map_func_counter
    _G[name] = fn
    local rhs = ':call v:lua.' .. name .. '()<CR>'
    api.nvim_set_keymap(mode, lhs, rhs, opts)
    map_func_counter = map_func_counter + 1
  end
end

for _, mode in ipairs {'', 'n', 'i', 'c', 'x'} do
  M[mode .. 'noremap'] = function(lhs, fn, opts)
    local mapopts = opts or {}
    mapopts.noremap = true
    return M.map(mode, lhs, fn, mapopts)
  end
end

function M.log_time(fn, label)
  return function(...)
    local now = os.clock()
    fn(...)
    print(
      ((label and (label .. ' ')) or '') ..
      (math.floor((os.clock() - now) * 1e6) / 1000) ..
      "ms."
    )
  end
end

function M.index_of(t, v, eqfn)
  eqfn = eqfn or (function(el) return el == v end)
  for i, value in ipairs(t) do
    if eqfn(value, v) then
      return i
    end
  end
  return -1
end

local globalfn_counter = 0
function M.defglobalfn(func)
  assert(type(func) == "function")
  local name = "_lua_fn_" .. globalfn_counter
  _G[name] = func
  globalfn_counter = globalfn_counter + 1
  return name
end

return M
