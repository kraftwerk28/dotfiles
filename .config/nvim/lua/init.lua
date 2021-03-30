local M = {}

local utils = require 'utils'
local highlight = require 'vim.highlight'

M.show_lsp_diagnostics = (function()
    local show_diagnostics = vim.lsp.diagnostic.show_line_diagnostics
    local cursor_pos = utils.get_cursor_pos()
    local debounced = utils.debounce(show_diagnostics, 300)
    return function()
        local cursor_pos2 = utils.get_cursor_pos()
        -- TODO: doesn't work when both diagnostics and popup is shown
        if cursor_pos[1] ~= cursor_pos2[1] and cursor_pos[2] ~= cursor_pos2[2] then
            cursor_pos = cursor_pos2
            debounced()
        end
    end
end)()

function M.format_code()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        utils.format_formatprg()
    else
        vim.lsp.buf.formatting()
    end
end

function M.yank_highlight() highlight.on_yank {timeout = 1000} end

function M.attach_completion()
    local ok, completion = pcall(require, 'completion')
    if ok then completion.on_attach() end
end

function M.run_prettier()
    if vim.fn.executable('prettier') == 0 then return end
    local ft = vim.bo.filetype
    local parser
    if ft == 'typescript' or ft == 'typescriptreact' then
        parser = 'typescript'
    elseif ft == 'javascript' or ft == 'javascriptreact' then
        parser = 'babel'
    end
    local old_formatprg = vim.bo.formatprg
    vim.bo.formatprg = 'prettier --parser ' .. parser
    utils.format_formatprg()
    vim.bo.formatprg = old_formatprg
end

function M.setup() utils.load('plugins') end

return M
