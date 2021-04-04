local M = {}

local function printf(...) print(string.format(...)) end
local sprintf = string.format
local function cmdf(...) vim.cmd(sprintf(...)) end

M.printf = printf
M.sprintf = sprintf
M.cmdf = cmdf

function M.get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

function M.debounce(func, timeout)
    local timer_id
    return function(...)
        if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
        local args = {...}
        local function cb()
            func(args)
            timer_id = nil
        end
        timer_id = vim.fn.timer_start(timeout, cb)
    end
end

-- FIXME
function M.throttle(func, timeout)
    local timer_id
    local did_call = false
    return function(...)
        local args = {...}
        if timer_id == nil then
            func(args)
            local function cb()
                timer_id = nil
                if did_call then
                    func(args)
                    did_call = false
                end
            end
            timer_id = vim.fn.timer_start(timeout, cb)
        else
            did_call = true
        end
    end
end

function M.format_formatprg()
    local opt_exists, formatprg = pcall(function() return vim.bo.formatprg end)
    if opt_exists and #formatprg > 0 then
        local view = vim.fn.winsaveview()
        vim.api.nvim_command('normal gggqG')
        vim.fn.winrestview(view)
        return true
    else
        return false
    end
end

-- Convert UTF-8 hex code to character
function M.u(code)
    if type(code) == 'string' then code = tonumber('0x' .. code) end
    local c = string.char
    if code <= 0x7f then return c(code) end
    local t = {}
    if code <= 0x07ff then
        t[1] = c(bit.bor(0xc0, bit.rshift(code, 6)))
        t[2] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    elseif code <= 0xffff then
        t[1] = c(bit.bor(0xe0, bit.rshift(code, 12)))
        t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
        t[3] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    else
        t[1] = c(bit.bor(0xf0, bit.rshift(code, 18)))
        t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
        t[3] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
        t[4] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    end
    return table.concat(t)
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
        if type(mod) == 'function' then
            loadfunc = mod
        elseif mod.setup ~= nil then
            loadfunc = mod.setup
        end
        local ok, err = pcall(loadfunc)
        if not ok then
            printf('Error loading module `%s`', path)
            print(err)
        end
    end
end

-- Get information about highlight group
function M.hl_by_name(hl_group)
    local hl = vim.api.nvim_get_hl_by_name(hl_group, true)
    if hl.foreground ~= nil then hl.fg = sprintf('#%x', hl.foreground) end
    if hl.background ~= nil then hl.bg = sprintf('#%x', hl.background) end
    return hl
end

-- Define a new highlight group
-- TODO: rewrite to `nvim_set_hl()` when API will be stable
function M.highlight(cfg)
    local command = 'highlight'
    if cfg.bang == true then command = command .. '!' end

    -- :highlight link
    if #cfg == 2 and type(cfg[1]) == 'string' and type(cfg[2]) == 'string' then
        command = command .. ' link ' .. cfg[1] .. ' ' .. cfg[2]
        vim.cmd(command)
        return
    end

    local fg = cfg.fg or cfg.guifg or cfg[2]
    local bg = cfg.bg or cfg.guibg or cfg[3]
    local style = cfg.gui or cfg[4]
    local underline = cfg.guisp or cfg[5]

    command = command .. ' ' .. cfg[1]
    if fg ~= nil then command = command .. ' guifg=' .. fg end
    if bg ~= nil then command = command .. ' guibg=' .. bg end
    if style ~= nil then command = command .. ' gui=' .. style end
    if underline ~= nil then command = command .. ' guisp=' .. style end
    vim.cmd(command)
end

local autocmd_fn_index = 0

function M.autocmd(event_name, pattern, callback)
    local fn_name = 'lua_autocmd' .. autocmd_fn_index
    autocmd_fn_index = autocmd_fn_index + 1
    _G[fn_name] = callback
    cmdf('autocmd %s %s call v:lua.%s()', event_name, pattern, fn_name)
end

function M.glob_exists(path)
    return vim.fn.empty(vim.fn.glob(path)) == 0
end

-- function M.highlight(hl_group, fg, bg, gui)
--   local guifg = fg and ' guifg=' .. fg or ''
--   local guibg = bg and ' guibg=' .. bg or ''
--   local gui = gui and ' gui=' .. gui or ''
--   vim.cmd('highlight ' .. hl_group .. guibg .. guifg .. gui)
-- end

return M
