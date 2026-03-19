return {
  "stevearc/conform.nvim",
  opts = function()
    local prettier_ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "css",
      "sass",
      "scss",
      "less",
      "html",
      "markdown",
      "json",
      "graphql",
      "yaml",
    }
    local formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      -- proto = { "clang-format" },
    }
    for _, ft in ipairs(prettier_ft) do
      formatters_by_ft[ft] = { "prettierd" }
    end

    return {
      formatters_by_ft = formatters_by_ft,
      default_format_opts = {
        lsp_format = "fallback",
      },
    }
  end,
  keys = {
    {
      "<Leader>f",
      function()
        require "conform".format()
      end,
      mode = "n",
      desc = "[F]ormat",
    },
  },
}
