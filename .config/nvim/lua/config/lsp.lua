local utils = require("config.utils")

local lsp, fn = vim.lsp, vim.fn
local highlight = utils.highlight

-- highlight {"DiagnosticUnderlineHint", gui = "undercurl"}
-- highlight {"DiagnosticUnderlineInformation", gui = "undercurl"}
-- highlight {
--   "DiagnosticUnderlineWarning",
--   gui = "undercurl",
--   -- guisp = "Orange",
-- }
-- highlight {"DiagnosticsUnderlineError", gui = "undercurl", guisp = "Red"}
-- highlight {"DiagnosticUnderlineError", gui = "undercurl"}

-- highlight {"DiagnosticsHint", fg = "Yellow"}
highlight {"DiagnosticInfo", guifg = "LightBlue"}
highlight {"DiagnosticWarn", guifg = "Orange"}
-- highlight {"DiagnosticsError", fg = "Red"}
highlight {"FloatBorder", guifg = "gray"}

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

local function setup_hover()
  local method = "textDocument/hover"
  lsp.handlers[method] = lsp.with(
    lsp.handlers[method],
    {border = vim.g.floatwin_border}
  )
end

local USE_DIAGNOSTIC_QUICKFIX = false

local function setup_diagnostics()
  local method = "textDocument/publishDiagnostics"
  local diagnostics_handler = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    update_in_insert = false,
    -- border = win_border,
  })
  lsp.handlers[method] = diagnostics_handler

  if USE_DIAGNOSTIC_QUICKFIX then
    lsp.handlers[method] = function(...)
      diagnostics_handler(...)
      local all_diagnostics = vim.lsp.diagnostic.get_all()
      local qflist = {}
      for bufnr, diagnostic in pairs(all_diagnostics) do
        for _, diag in ipairs(diagnostic) do
          local item = {
            bufnr = bufnr,
            lnum = diag.range.start.line + 1,
            col = diag.range.start.character + 1,
            text = diag.message,
          }
          if diag.severity == 1 then
            item.type = 'E'
          elseif diag.severity == 2 then
            item.type = 'W'
          end
          table.insert(qflist, item)
        end
      end
      fn.setqflist(qflist)
    end
  end
end

local function setup_formatting()
  local method = "textDocument/formatting"
  local defaut_handler = lsp.handlers[method]
  lsp.handlers[method] = function(...)
    -- local err, method, result, client_id, bufnr, config = ...
    -- dump {
    --   err = err,
    --   method = method,
    --   result = result,
    --   client_id = client_id,
    --   bufnr = bufnr,
    --   config = config,
    -- }
    local err = ...
    if err == nil then
      defaut_handler(...)
    else
      vim.cmd("Neoformat")
    end
  end
end

setup_diagnostics()
-- setup_formatting()
setup_hover()
