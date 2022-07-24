local lsp, fn, api = vim.lsp, vim.fn, vim.api

-- highlight {"DiagnosticUnderlineHint", gui = "undercurl"}
-- highlight {"DiagnosticUnderlineInformation", gui = "undercurl"}
-- highlight {
--   "DiagnosticUnderlineWarning",
--   gui = "undercurl",
--   -- guisp = "Orange",
-- }
-- highlight {"DiagnosticsUnderlineError", gui = "undercurl", guisp = "Red"}
-- highlight {"DiagnosticUnderlineError", gui = "undercurl"}
-- --

-- local ns = api.nvim_create_namespace("lsp-hl")

-- highlight {"DiagnosticsHint", fg = "Yellow"}
-- api.nvim_set_hl(ns, "DiagnosticInfo", { fg = "LightBlue" })
-- highlight {"DiagnosticWarn", guifg = "Orange"}
-- highlight {"DiagnosticsError", fg = "Red"}
-- api.nvim_set_hl(ns, "FloatBorder", { fg = "Gray" })

fn.sign_define("DiagnosticSignHint", {
  text = vim.g.diagnostic_signs.HINT,
  texthl = "DiagnosticSignHint",
})
fn.sign_define("DiagnosticSignInfo", {
  text = vim.g.diagnostic_signs.INFO,
  texthl = "DiagnosticSignInfo",
})
fn.sign_define("DiagnosticSignWarn", {
  text = vim.g.diagnostic_signs.WARN,
  texthl = "DiagnosticSignWarn",
})
fn.sign_define("DiagnosticSignError", {
  text = vim.g.diagnostic_signs.ERROR,
  texthl = "DiagnosticSignError",
})

local function override_hl(name, val)
  local h = api.nvim_get_hl_by_name(name, true)
  api.nvim_set_hl(0, name, vim.tbl_extend("force", h, val))
end

-- override_hl("DiagnosticUnderlineError", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineWarn", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineHint", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineInfo", { underline = true, undercurl = false })

local tb = require("telescope.builtin")
local opts = { silent = true }

vim.keymap.set("n", "<Leader>f", vim.lsp.buf.format, opts)
vim.keymap.set("v", "<Leader>f", vim.lsp.buf.range_formatting, opts)
vim.keymap.set("n", "<Leader>ah", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<Leader>aj", tb.lsp_definitions, opts)
vim.keymap.set("n", "<Leader>ae", function()
  vim.diagnostic.open_float({ border = vim.g.floatwin_border })
end, opts)
vim.keymap.set("n", "<Leader>aa", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<Leader>as", tb.lsp_document_symbols, opts)
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, opts)

do
  local m = "textDocument/signatureHelp"
  lsp.handlers[m] =
    lsp.with(lsp.handlers[m], { border = vim.g.floatwin_border })
end

do
  local m = "textDocument/hover"
  lsp.handlers[m] =
    lsp.with(lsp.handlers[m], { border = vim.g.floatwin_border })
end

do
  local m = "textDocument/publishDiagnostics"
  lsp.handlers[m] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 2,
      prefix = "",
    },
  })
end
