return {
  "lervag/vimtex",
  ft = { "tex" },
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    vim.g.vimtex_syntax_enabled = 0 -- treesitter FTW
    vim.g.vimtex_view_method = "general"
    -- vim.g.vimtex_view_method = "zathura"
  end,
}
