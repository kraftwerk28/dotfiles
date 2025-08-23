-- fn.sign_define({
--   {
--     name = "DiagnosticSignHint",
--     text = vim.g.diagnostic_signs.HINT,
--     texthl = "DiagnosticSignHint",
--   },
--   {
--     name = "DiagnosticSignInfo",
--     text = vim.g.diagnostic_signs.INFO,
--     texthl = "DiagnosticSignInfo",
--   },
--   {
--     name = "DiagnosticSignWarn",
--     text = vim.g.diagnostic_signs.WARN,
--     texthl = "DiagnosticSignWarn",
--   },
--   {
--     name = "DiagnosticSignError",
--     text = vim.g.diagnostic_signs.ERROR,
--     texthl = "DiagnosticSignError",
--   },
-- })

local function override_hl(name, val)
  local h = vim.api.nvim_get_hl_by_name(name, true)
  vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", h, val))
end

-- override_hl("DiagnosticUnderlineError", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineWarn", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineHint", { underline = true, undercurl = false })
-- override_hl("DiagnosticUnderlineInfo", { underline = true, undercurl = false })

autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local cap = client.server_capabilities
    if not cap then
      return
    end

    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
      end, { buffer = true })
    end

    -- NOTE: handled by blink.cmp
    -- if client:supports_method("textDocument/signatureHelp") then
    --   vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, {
    --     buffer = true,
    --   })
    -- end

    if cap.documentFormattingProvider then
      -- NOTE: conform.nvim manages LSP formatting for us, skip keymap setting
      -- vim.keymap.set("n", "<Leader>f", function()
      --   vim.lsp.buf.format({ timeout_ms = 5000, async = false })
      -- end, { buffer = true, desc = "[F]ormat" })
    end

    -- Under-cursor LSP mappings
    if client:supports_method("textDocument/rename") then
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
        buffer = true,
        desc = "[C]ursor [R]ename",
      })
    end

    if client:supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, {
        buffer = true,
        desc = "[C]ode [A]ctions",
      })
    end

    local tb = require "telescope.builtin"

    if client:supports_method("textDocument/references") then
      vim.keymap.set("n", "gr", tb.lsp_references, {
        buffer = true,
        desc = "Goto References",
      })
    end

    if client:supports_method("textDocument/definition") then
      -- <Leader> is not used here as it is often executed mapping
      vim.keymap.set("n", "gd", tb.lsp_definitions, {
        buffer = true,
        desc = "Goto Definition",
      })
    end

    if client:supports_method("textDocument/declaration") then
      -- <Leader> is not used here as it is often executed mapping
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
        buffer = true,
        desc = "Goto Declaration",
      })
    end

    if cap.typeDefinitionProvider then
      vim.keymap.set("n", "gt", tb.lsp_type_definitions, {
        buffer = true,
        desc = "Goto Type Definition",
      })
    end

    if cap.implementationProvider then
      vim.keymap.set("n", "gI", tb.lsp_implementations, {
        buffer = true,
        desc = "Goto Implementation",
      })
    end

    if cap.documentSymbolProvider then
      vim.keymap.set("n", "gsd", tb.lsp_document_symbols, {
        buffer = true,
        desc = "Goto Document Symbols",
      })
    end

    if cap.workspaceSymbolProvider then
      vim.keymap.set("n", "gsw", tb.lsp_workspace_symbols, {
        buffer = true,
        desc = "Goto Workspace Symbols",
      })
    end

    if client:supports_method("textDocument/foldingRange") then
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

-- if vim.g.borderchars ~= nil then
--   local h = vim.lsp.handlers
--   h["textDocument/signatureHelp"] = vim.lsp.with(
--     h["textDocument/signatureHelp"],
--     { border = vim.g.borderchars }
--   )
--   h["textDocument/hover"] =
--     vim.lsp.with(h["textDocument/hover"], { border = vim.g.borderchars })
-- end

-- lsp.handlers["textDocument/publishDiagnostics"] =
--   lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--       spacing = 2,
--       prefix = "",
--     },
--   })

require("kraftwerk28.lsp.manage")
require("kraftwerk28.lsp.servers")
