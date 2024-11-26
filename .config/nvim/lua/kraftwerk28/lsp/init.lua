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
    local cap = client.server_capabilities

    if cap.hoverProvider then
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
    end

    if cap.signatureHelpProvider then
      vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, {
        buffer = true,
      })
    end

    if cap.documentFormattingProvider then
      -- NOTE: conform.nvim manages LSP formatting for us, skip keymap setting
      -- vim.keymap.set("n", "<Leader>f", function()
      --   vim.lsp.buf.format({ timeout_ms = 5000, async = false })
      -- end, { buffer = true, desc = "[F]ormat" })
    end

    -- Under-cursor LSP mappings
    if cap.renameProvider then
      vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {
        buffer = true,
        desc = "Rename under Cursor",
      })
    end

    if cap.codeActionProvider then
      vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, {
        buffer = true,
        desc = "[C]ode [A]ctions",
      })
    end

    vim.keymap.set("n", "<Leader>dc", function()
      vim.diagnostic.open_float({ border = vim.g.borderchars })
    end, {
      buffer = true,
      desc = "[D]iagnostics under [C]ursor",
    })

    local tb = require("telescope.builtin")

    vim.keymap.set("n", "<Leader>da", tb.diagnostics, {
      buffer = true,
      desc = "[D]iagnostics [A]ll",
    })

    if cap.referencesProvider then
      vim.keymap.set("n", "<Leader>gr", tb.lsp_references, {
        buffer = true,
        desc = "[G]oto [R]eferences",
      })
    end
    if cap.definitionProvider then
      -- <Leader> is not used here as it is often executed mapping
      vim.keymap.set("n", "gd", tb.lsp_definitions, {
        buffer = true,
        desc = "[G]oto [D]efinition",
      })
    end
    if cap.declarationProvider then
      -- <Leader> is not used here as it is often executed mapping
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
        buffer = true,
        desc = "[G]oto [D]eclaration",
      })
    end
    if cap.typeDefinitionProvider then
      vim.keymap.set("n", "<Leader>gt", tb.lsp_type_definitions, {
        buffer = true,
        desc = "[G]oto [T]ypedef",
      })
    end
    if cap.implementationProvider then
      vim.keymap.set("n", "<Leader>gi", tb.lsp_implementations, {
        buffer = true,
        desc = "[G]oto [I]mplementation",
      })
    end
    if cap.documentSymbolProvider then
      vim.keymap.set("n", "<Leader>gds", tb.lsp_document_symbols, {
        buffer = true,
        desc = "[G]oto [D]ocument [S]ymbols",
      })
    end
    if cap.workspaceSymbolProvider then
      vim.keymap.set("n", "<Leader>gws", tb.lsp_workspace_symbols, {
        buffer = true,
        desc = "[G]oto [W]orkspace [S]ymbols",
      })
    end
  end,
})

if vim.g.borderchars ~= nil then
  local h = vim.lsp.handlers
  h["textDocument/signatureHelp"] = vim.lsp.with(
    h["textDocument/signatureHelp"],
    { border = vim.g.borderchars }
  )
  h["textDocument/hover"] =
    vim.lsp.with(h["textDocument/hover"], { border = vim.g.borderchars })
end

-- lsp.handlers["textDocument/publishDiagnostics"] =
--   lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--       spacing = 2,
--       prefix = "",
--     },
--   })

require("kraftwerk28.lsp.manage")
require("kraftwerk28.lsp.servers")
