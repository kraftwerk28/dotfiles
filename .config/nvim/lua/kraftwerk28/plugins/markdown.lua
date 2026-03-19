return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.cmd [[
      function MkdpOpenFirefox(url)
        silent! execute('!firefox -P markdown-preview --new-window=' . a:url . ' &')
      endfunction
    ]]
    vim.g.mkdp_browserfunc = "MkdpOpenFirefox"

    -- TODO: find why v:lua doesn't work here
    -- _G.mkdp_open_firefox = function(url)
    --   vim.cmd(
    --     ("silent! !firefox -P markdown-preview --new-window=%s &"):format(url)
    --   )
    -- end
    -- vim.g.mkdp_browserfunc = "v:lua.mkdp_open_firefox"
  end,
}
