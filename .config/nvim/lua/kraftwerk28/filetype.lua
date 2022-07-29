vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    vert = "glsl",
    frag = "glsl",
    mjml = "html",
    ejs = "html",
    bnf = "bnf",
    http = "rest",
    mts = "typescript",
    mtsx = "typescriptreact",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
    [".eslintrc"] = "json",
    ["go.mod"] = "gomod",
  },
  pattern = {
    ["exs?$"] = "elixir",
    ["^%.env%."] = "sh",
    ["%.webmanifest$"] = "json",
  },
})

-- Set options for filetypes
local ftconfig = {
  {
    { "go", "make", "c", "cpp", "meson" },
    { shiftwidth = 4, tabstop = 4, expandtab = false },
  },

  {
    { "java", "kotlin", "groovy", "csharp", "cabal", "python" },
    { shiftwidth = 4, tabstop = 4, expandtab = true },
  },

  {
    {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "json",
      "jsonc",
      "vim",
      "yaml",
      "haskell",
      "lisp",
      "lua",
      "graphql",
      "markdown",
    },
    { shiftwidth = 2, tabstop = 2, expandtab = true },
  },

  { { "jess" }, { commentstring = "; %s" } },

  { { "json", "jsonc", "cjson" }, { commentstring = "// %s" } },

  { { "asm" }, { shiftwidth = 8, tabstop = 8, expandtab = false } },

  { { "help" }, { conceallevel = 0 } },

  -- { { "markdown" }, { conceallevel = 2 } },

  { { "graphql" }, { commentstring = "# %s" } },

  { { "dosini", "confini" }, { commentstring = "; %s" } },

  {
    { "python", "typescript", "typescriptreact" },
    { indentexpr = "nvim_treesitter#indent()" },
  },
}

local filetype_opts = aug("filetype_opts")
for _, cfg in ipairs(ftconfig) do
  local filetypes, opts = cfg[1], cfg[2]
  au("FileType", {
    pattern = filetypes,
    callback = function()
      for name, value in pairs(opts) do
        vim.opt_local[name] = value
      end
    end,
    group = filetype_opts,
  })
end
