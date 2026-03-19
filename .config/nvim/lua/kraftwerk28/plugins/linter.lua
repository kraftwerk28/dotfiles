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
      svelte = { "eslint_d" },
    }

    ---@param filename string
    local function enabled(filename)
      if filename == "PKGBUILD" or filename:match("%.PKGBUILD$") then
        -- Skip shellcheck for AUR PKGBUILDs
        return false
      end
      if filename == ".env" or filename:match("^%.env%.") then
        return false
      end
      return true
    end

    autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      callback = function(arg)
        local name = vim.fn.fnamemodify(arg.match, ":t")
        if enabled(name) then
          lint.try_lint()
        end
      end,
    })
  end,
}
