return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = false,
    opts = {
      enable_autocmd = false,
      languages = {
        c = {
          __default = [[// %s]],
          __multiline = [[/* %s */]],
        },
        -- zsh = {
        --   __default = [[# %s]],
        -- },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    lazy = false,
    keys = {
      { "<C-/>", "gccj", mode = "n", remap = true },
      { "<C-/>", "gcgv", mode = "x", remap = true },
    },
    opts = function()
      local integration =
        require "ts_context_commentstring.integrations.comment_nvim"
      return {
        pre_hook = integration.create_pre_hook(),
      }
    end,
  },
}
