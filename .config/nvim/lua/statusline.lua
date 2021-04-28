local colors = require('cfg.colors')
local utils = require('utils')

local u = utils.u
local sprintf = utils.sprintf
local highlight = utils.highlight

local cl = colors.from_base16(vim.g.base16_theme)

local mode_map = {
    ['n'] = {'NORMAL', cl.normal},
    ['i'] = {'INSERT', cl.insert},
    ['R'] = {'REPLACE', cl.replace},
    ['v'] = {'VISUAL', cl.visual},
    ['V'] = {'V-LINE', cl.visual},
    ['c'] = {'COMMAND', cl.command},
    ['s'] = {'SELECT', cl.visual},
    ['S'] = {'S-LINE', cl.visual},
    ['t'] = {'TERMINAL', cl.terminal},
    [''] = {'V-BLOCK', cl.visual},
    [''] = {'S-BLOCK', cl.visual},
    ['Rv'] = {'VIRTUAL'},
    ['rm'] = {'--MORE'},
}

local icons = {
    locker = u 'f023',
    unsaved = u 'f693',
    dos = u 'e70f',
    unix = u 'f17c',
    mac = u 'f179',
    lsp_warn = u 'f071',
    lsp_error = u 'f46e',
    lsp_server_icon = u 'f817',
    lsp_server_disconnected = u 'f818',
    col_num = u 'e0a3',
    line_num = u 'e0a1',
}

local function stl_mode()
    local m = mode_map[vim.fn.mode()]
    highlight {'StatusLine', cl.fg, cl.bg, 'bold'}
    highlight {'StatusLineModeInv', m[2], cl.bg, 'reverse,bold'}
    highlight {'StatusLineMode', m[2], cl.bg, 'bold'}
    if vim.fn.winwidth(0) > 80 then
        return m[1]
    else
        return m[1]:sub(1, 1)
    end
end

local function fileicon()
    local devicons = require 'nvim-web-devicons'
    local filename, fileext = vim.fn.expand '%:t', vim.fn.expand '%:e'
    local icon, icon_hl = devicons.get_icon(filename, fileext)
    local fg = cl.fg
    if icon_hl ~= nil then fg = utils.hl_by_name(icon_hl).fg end
    highlight {'StatusLineFileIcon', fg, cl.bg}
    return icon or ''
end

local function format_icon() return icons[vim.bo.fileformat] or '' end

local function filetype() return vim.bo.filetype end

local function file_attrs()
    local result = ''
    if vim.bo.readonly then result = result .. ' ' .. icons.locker end
    if vim.bo.modified then result = result .. ' ' .. icons.unsaved end
    return result
end

local function lsp_connected()
    local connected = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
    local icon = connected and icons.lsp_server_icon or
                   icons.lsp_server_disconnected
    local icon_cl = connected and cl.lsp_active or cl.lsp_inactive
    highlight {'StatusLineLspConn', icon_cl, cl.bg}
    return icon .. ' '
end

local function lsp_count(kind, icon)
    local n = vim.lsp.diagnostic.get_count(0, kind)
    if n == 0 then return '' end
    return sprintf('%s %d', icon, n)
end

local function lsp_warns() return lsp_count('Warning', icons.lsp_warn) end
local function lsp_errors() return lsp_count('Error', icons.lsp_error) end

local function percent()
    local cur, total = vim.fn.line '.', vim.fn.line '$'
    if cur == 1 then
        return ' Top'
    elseif cur == total then
        return ' Bot'
    else
        local frac = (cur / total) * 100
        local rounded = frac + 0.5 - (frac + 0.5) % 1
        return sprintf('% 3d%%', rounded)
    end
end

local function charhex()
    local col = vim.fn.col '.'
    local ch = vim.fn.getline '.':sub(col, col)
    return sprintf('0x%04x', vim.fn.char2nr(ch))
end

local function get_padding(cfg)
    local lp, rp = 0, 0
    if cfg.padl ~= nil then lp = cfg.padl end
    if cfg.padr ~= nil then rp = cfg.padr end
    if cfg.padding ~= nil then
        lp = cfg.padding
        rp = cfg.padding
    end
    return lp, rp
end

local function component_builder()
    local stl, cnt = {}, 0
    _G._stl = stl

    return function(cfg)
        local result = ''
        local lpad, rpad = get_padding(cfg)
        local has_hl = type(cfg.hl) == 'string'
        local has_cond = type(cfg.cond) == 'function'

        local cond_expr = ''
        if has_cond then
            local cond_fn = 'cfn' .. cnt
            cnt = cnt + 1
            stl[cond_fn] = cfg.cond
            cond_expr = sprintf('v:lua._stl.%s()', cond_fn)
        end
        -- Left separator
        if cfg.lsep ~= nil then
            if cfg.lsep.hl ~= nil then
                result = result .. '%#' .. cfg.lsep.hl .. '#'
            end
            local sep = cfg.lsep[1] or cfg.lsep
            if has_cond then
                result = result ..
                           sprintf('%%{%s ? \'%s\' : \'\'}', cond_expr, sep)
            else
                result = result .. sep
            end
        end
        if has_hl then result = result .. '%#' .. cfg.hl .. '#' end
        if type(cfg[1]) == 'function' then
            result = result .. '%{'
            -- Condition start
            if has_cond then result = result .. cond_expr .. ' ? ' end
            -- Left padding
            if lpad > 0 then
                result = result .. '\'' .. string.rep(' ', lpad) .. '\'.'
            end
            -- Component
            local fn_name = 'fn' .. cnt
            cnt = cnt + 1
            stl[fn_name] = cfg[1]
            result = result .. sprintf('v:lua._stl.%s()', fn_name)
            -- Right padding
            if rpad > 0 then
                result = result .. '.\'' .. string.rep(' ', rpad) .. '\''
            end
            -- Condition end
            if has_cond then result = result .. ' : \'\'' end
            result = result .. '}'

        elseif type(cfg[1]) == 'string' then
            result = result .. string.rep('\\ ', lpad) .. cfg[1] ..
                       string.rep('\\ ', rpad)

        else
            error 'cfg[1] must be either function or string'
        end

        -- Right separator
        if cfg.rsep ~= nil then
            if cfg.rsep.hl ~= nil then
                result = result .. '%#' .. cfg.rsep.hl .. '#'
            end
            local sep = cfg.rsep[1] or cfg.rsep
            if has_cond then
                result = result ..
                           sprintf('%%{%s ? \'%s\' : \'\'}', cond_expr, sep)
            else
                result = result .. sep
            end
        end

        return result
    end
end

local function buf_nonempty()
    if vim.fn.empty(vim.fn.expand '%:t') ~= 1 then return true end
    return false
end

local function iswide() return vim.fn.winwidth(0) > 80 end

local comp = component_builder()

local function build_stl()
    -- Left
    local mode = comp {stl_mode, hl = 'StatusLineModeInv', padl = 2, padr = 1}
    local fileformat = comp {
        format_icon,
        hl = 'StatusLine',
        padl = 2,
        cond = buf_nonempty,
    }
    local filetype = comp {
        filetype,
        hl = 'StatusLine',
        cond = buf_nonempty,
        padl = 2,
        padr = 1,
        rsep = {'|', hl = 'StatusLineMode'},
    }
    local char_hex = comp {charhex, hl = 'StatusLine', padl = 2, cond = iswide}

    -- Center
    local icon = comp {
        fileicon,
        hl = 'StatusLineFileIcon',
        cond = buf_nonempty,
        padr = 1,
    }
    local filename = comp {'%t', hl = 'StatusLine'}
    local fileattrs = comp {file_attrs, hl = 'StatusLine'}

    -- Right
    local lsp_conn = comp {lsp_connected, hl = 'StatusLineLspConn'}
    local lsp_w = comp {lsp_warns, hl = 'StatusLineWarning'}
    local lsp_e = comp {lsp_errors, hl = 'StatusLineError'}
    local col_row = comp {
        icons.line_num .. '%l ' .. icons.col_num .. '%c',
        hl = 'StatusLineModeInv',
        lsep = {u '2590', hl = 'StatusLineMode'},
    }
    local pos_percent = comp {
        percent,
        cond = iswide,
        lsep = {'|', hl = 'StatusLineModeInv'},
        padr = 1,
    }
    local reset_hl = '%#StatusLine#'

    return table.concat {
        mode, fileformat, filetype, char_hex, reset_hl, '%=', icon, filename,
        fileattrs, '%=', lsp_conn, lsp_w, lsp_e, col_row, pos_percent,
    }
end

local function build_inactive_stl()
    local icon = comp {
        fileicon,
        hl = 'StatusLineFileIcon',
        cond = buf_nonempty,
        padr = 1,
    }
    local filename = comp {'%f', hl = 'StatusLine'}
    local fileattrs = comp {file_attrs, hl = 'StatusLine'}

    local lsp_conn = comp {lsp_connected, hl = 'StatusLineLspConn'}
    local lsp_w = comp {lsp_warns, hl = 'StatusLineWarning'}
    local lsp_e = comp {lsp_errors, hl = 'StatusLineError'}

    return table.concat {
        '%#StatusLine#%=', icon, filename, fileattrs, '%=', lsp_conn, lsp_w,
        lsp_e,
    }
end

_G.stl = {}
function _G.stl.attach_stl()
    highlight {'StatusLineWarning', 'yellow', cl.bg}
    highlight {'StatusLineError', 'red', cl.bg}
    if vim.g.statusline_winid == vim.fn.win_getid() then
        return build_stl()
    else
        return build_inactive_stl()
    end
end

-- local frames = {
--   '', '', '', '', '', '', '', '', '', '', '',
--   '', '', '', '', '', '', '', '', '', '', '',
--   '', '', '', '', '', '',
-- }
-- TODO: make spinner components for status feedback
-- local function make_spinner()
--   local frames = {'/', '-', '\\', '|'}
--   local nthframe = 0
--   local function update_spinner()
--     nthframe = (nthframe + 1) % #frames
--     -- Note: no :redrawstatus here
--   end
--   vim.fn.timer_start(200, update_spinner, {['repeat'] = -1})
--   return function() return frames[nthframe + 1] end
-- end

return function()
    vim.api.nvim_exec(
      [[
      setlocal statusline=%!v:lua.stl.attach_stl()
      augroup stl_autocommands
        autocmd!
        autocmd BufEnter,WinEnter,BufLeave,WinLeave * setlocal statusline=%!v:lua.stl.attach_stl()
      augroup END
    ]], false
    )
end
