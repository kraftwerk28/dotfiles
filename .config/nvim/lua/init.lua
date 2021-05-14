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

-- :Neoformat will be always ran in these filetypes
vim.g.force_neoformat_filetypes = {
    'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'lua',
}

function M.format_code()
    if vim.tbl_contains(vim.g.force_neoformat_filetypes, vim.bo.filetype) or
      vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        vim.cmd('Neoformat')
    else
        vim.lsp.buf.formatting()
    end
end

function M.yank_highlight() highlight.on_yank {timeout = 1000} end

function M.attach_completion()
    local ok, completion = pcall(require, 'completion')
    if ok then completion.on_attach() end
end

pcall(
  function()
      vim.g.base16_theme = 'classic-dark'
      local base16 = require('base16-colorscheme')
      base16.setup(vim.g.base16_theme)
      -- local b16 = require('base16')
      -- b16(b16.themes['onedark'], true)
      -- vim.g.ayucolor = 'mirage'
      -- vim.cmd('colorscheme ayu')
      -- vim.cmd('autocmd ColorScheme ayu highlight! link VertSplit Comment')
      -- utils.highlight {'VertSplit', 'Comment', bang = true}
  end
)

utils.load('plugins')
utils.load('tabline')
utils.load('statusline')

return M
