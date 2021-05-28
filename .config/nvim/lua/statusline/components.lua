local make_component = require('statusline.impl').make_component
local M = {}

M.alignment_separator = make_component {'%='}
M.reset_highlight = make_component {'%#StatusLine#'}

return M
