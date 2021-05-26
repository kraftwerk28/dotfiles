local utils = require('utils')
local highlight = utils.highlight
local colors = require('cfg.colors')

return function()
    local cl = colors.from_base16(vim.g.base16_theme)
    -- TabLine - tab pages line, not active tab page label
    -- TabLineFill - tab pages line, where there are no labels
    -- TabLineSel - tab pages line, active tab page label
    highlight {'TabLine', guibg = 'bg', gui = 'NONE', bang = true}
    highlight {'TabLineFill', guibg = 'bg', gui = 'NONE', bang = true}
    highlight {
        'TabLineSel',
        bg = cl.normal,
        fg = cl.bg,
        gui = 'bold',
        bang = true,
    }
    -- highlight {'TabLineSel', 'StatusLineModeInv', bang = true}
end
