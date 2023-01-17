local lsp, fn, api = vim.lsp, vim.fn, vim.api

require("kraftwerk28.lsp.manage")

fn.sign_define({
  {
    name = "DiagnosticSignHint",
    text = vim.g.diagnostic_signs.HINT,
    texthl = "DiagnosticSignHint",
  },
  {
    name = "DiagnosticSignInfo",
    text = vim.g.diagnostic_signs.INFO,
    texthl = "DiagnosticSignInfo",
  },
  {
    name = "DiagnosticSignWarn",
    text = vim.g.diagnostic_signs.WARN,
    texthl = "DiagnosticSignWarn",
  },
  {
    name = "DiagnosticSignError",
    text = vim.g.diagnostic_signs.ERROR,
    texthl = "DiagnosticSignError",
  },
})

local function override_hl(name, val)
  local h = api.nvim_get_hl_by_name(name, true)
  api.nvim_set_hl(0, name, vim.tbl_extend("force", h, val))
end

override_hl("DiagnosticUnderlineError", { underline = true, undercurl = false })
override_hl("DiagnosticUnderlineWarn", { underline = true, undercurl = false })
override_hl("DiagnosticUnderlineHint", { underline = true, undercurl = false })
override_hl("DiagnosticUnderlineInfo", { underline = true, undercurl = false })

local tb = require("telescope.builtin")

local mopt = { silent = true }
vim.keymap.set("n", "<Leader>f", function()
  vim.lsp.buf.format({ timeout_ms = 5000, async = false }, mopt)
end, mopt)
vim.keymap.set("n", "<Leader>ah", vim.lsp.buf.hover, mopt)
vim.keymap.set("n", "<Leader>aj", tb.lsp_definitions, mopt)
vim.keymap.set("n", "<Leader>ae", function()
  vim.diagnostic.open_float({ border = vim.g.borderchars }, mopt)
end, mopt)
vim.keymap.set("n", "<Leader>aa", vim.lsp.buf.code_action, mopt)
vim.keymap.set("n", "<Leader>as", tb.lsp_document_symbols, mopt)
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, mopt)
vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, mopt)

do
  local m = "textDocument/signatureHelp"
  lsp.handlers[m] = lsp.with(lsp.handlers[m], { border = vim.g.borderchars })
end

do
  local m = "textDocument/hover"
  lsp.handlers[m] = lsp.with(lsp.handlers[m], { border = vim.g.borderchars })
end

-- do
--   local m = "textDocument/publishDiagnostics"
--   lsp.handlers[m] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--       spacing = 2,
--       prefix = "",
--     },
--   })
-- end
