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
    -- NOTE: checking for client:supports_method("...") before setting each mapping doesn't always work

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local cap = client.server_capabilities
    if not cap then
      return
    end

    local tb = require "telescope.builtin"

    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, { buffer = args.buf })

    -- Under-cursor LSP mappings
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
      buffer = args.buf,
      desc = "[C]ursor [R]ename",
    })

    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, {
      buffer = args.buf,
      desc = "[C]ode [A]ctions",
    })

    vim.keymap.set("n", "gr", tb.lsp_references, {
      buffer = args.buf,
      desc = "Goto References",
    })

    -- <Leader> is not used here as it is often executed mapping
    vim.keymap.set("n", "gd", tb.lsp_definitions, {
      buffer = args.buf,
      desc = "Goto Definition",
    })

    -- <Leader> is not used here as it is often executed mapping
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
      buffer = args.buf,
      desc = "Goto Declaration",
    })

    if cap.typeDefinitionProvider then
      vim.keymap.set("n", "gt", tb.lsp_type_definitions, {
        buffer = args.buf,
        desc = "Goto Type Definition",
      })
    end

    if cap.implementationProvider then
      vim.keymap.set("n", "gI", tb.lsp_implementations, {
        buffer = args.buf,
        desc = "Goto Implementation",
      })
    end

    if cap.documentSymbolProvider then
      vim.keymap.set("n", "gsd", tb.lsp_document_symbols, {
        buffer = args.buf,
        desc = "Goto Document Symbols",
      })
    end

    if cap.workspaceSymbolProvider then
      vim.keymap.set("n", "gsw", tb.lsp_workspace_symbols, {
        buffer = args.buf,
        desc = "Goto Workspace Symbols",
      })
    end

    -- if client:supports_method("textDocument/foldingRange") then
    --   local winid = vim.api.nvim_get_current_win()
    --   vim.wo[winid][0].foldmethod = "expr"
    --   vim.wo[winid][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    -- end
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
