return {
  "mfussenegger/nvim-lint",
  init = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      bash = { "shellcheck" },
      sh = { "shellcheck" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      callback = function(arg)
        local name = vim.fn.fnamemodify(arg.match, ":t")
        if name == "PKGBUILD" or name:match("%.PKGBUILD$") then
          -- Skip shellcheck for AUR PKGBUILDs
          return
        end
        if name == ".env" or name:match("^%.env%.") then
          return
        end
        lint.try_lint()
      end,
    })
  end,
}
