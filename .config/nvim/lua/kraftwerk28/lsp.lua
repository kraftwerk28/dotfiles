local lsp, fn, api = vim.lsp, vim.fn, vim.api

-- api.create_user_command("LspLog", function()
--   vim.cmd("edit " .. vim.lsp.get_log_path())
-- end, { nargs = 0 })

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

m:opt({ silent = true })
m("n", "<Leader>f", function()
  vim.lsp.buf.format({ timeout_ms = 5000, async = false })
end, opts)
m("v", "<Leader>f", function()
  vim.lsp.buf.range_formatting()
end, opts)
m("n", "<Leader>ah", vim.lsp.buf.hover, opts)
m("n", "<Leader>aj", tb.lsp_definitions, opts)
m("n", "<Leader>ae", function()
  vim.diagnostic.open_float({ border = vim.g.borderchars })
end, opts)
m("n", "<Leader>aa", vim.lsp.buf.code_action, opts)
m("n", "<Leader>as", tb.lsp_document_symbols, opts)
m("n", "<F2>", vim.lsp.buf.rename, opts)
m("i", "<C-S>", vim.lsp.buf.signature_help, opts)
m:unopt()

do
  local m = "textDocument/signatureHelp"
  lsp.handlers[m] = lsp.with(lsp.handlers[m], { border = vim.g.borderchars })
end

do
  local m = "textDocument/hover"
  lsp.handlers[m] = lsp.with(lsp.handlers[m], { border = vim.g.borderchars })
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
