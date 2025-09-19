vim.g.do_filetype_lua = 1

vim.filetype.add {
  extension = {
    vert = "glsl",
    frag = "glsl",
    mjml = "html",
    ejs = "html",
    bnf = "bnf",
    http = "rest",
    mts = "typescript",
    mtsx = "typescriptreact",
    strace = "strace",
    porth = "porth",
    webmanifest = "json",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
    [".eslintrc"] = "json",
    ["go.mod"] = "gomod",
  },
  pattern = {
    ["%.env%..*"] = "sh",
    [".*%.PKGBUILD"] = "sh",
  },
}

-- Set options for filetypes
local ftconfig = {
  {
    ft = {
      "go",
      "make",
      "c",
      "cpp",
      "meson",
      "svelte",
      "bash",
      "sh",
      "hocon",
    },
    opts = { expandtab = false, shiftwidth = 0 },
  },
  {
    ft = {
      "cabal",
      "csharp",
      "dockerfile",
      "groovy",
      "java",
      "kotlin",
      "python",
      "erlang",
      "elixir",
    },
    opts = { expandtab = true, shiftwidth = 4 },
  },
  {
    ft = {
      "graphql",
      "haskell",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lisp",
      "lua",
      "markdown",
      "typescript",
      "typescriptreact",
      "vim",
      "yaml",
      "vue",
    },
    opts = { expandtab = true, shiftwidth = 2 },
  },
  { ft = "asm", opts = { expandtab = false, tabstop = 8, shiftwidth = 0 } },

  -- Misc options
  {
    fs = { "json", "jsonc", "cjson" },
    opts = { commentstring = "// %s" },
  },
  { ft = "help", opts = { conceallevel = 0 } },
  { ft = "graphql", opts = { commentstring = "# %s" } },
  {
    ft = { "dosini", "confini", "jess" },
    opts = { commentstring = "; %s" },
  },
  {
    ft = "hocon",
    opts = { commentstring = "# %s", cindent = true, cinoptions = "+0" },
  },

  {
    ft = { "c", "sh", "bash" },
    opts = { keywordprg = ":Man" },
  },

  { ft = { "sml" }, opts = { commentstring = "(* %s *)" } },

  { ft = { "markdown" }, opts = { breakindent = true } },
}

local filetype_opts = augroup("filetype_opts")
for _, cfg in ipairs(ftconfig) do
  autocmd("FileType", {
    pattern = cfg.ft,
    callback = function()
      for name, value in pairs(cfg.opts) do
        vim.o[name] = value
      end
    end,
    group = filetype_opts,
  })
end
