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
    strace = "strace",
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
    ["*/sway/config"] = "swayconfig",
  },
})

-- Set options for filetypes
local ftconfig = {
  {
    { "go", "make", "c", "cpp", "meson" },
    { expandtab = false },
  },

  {
    { "cabal", "csharp", "dockerfile", "groovy", "java", "kotlin", "python" },
    { expandtab = true },
  },

  {
    {
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
    },
    { shiftwidth = 2, expandtab = true },
  },

  {
    { "json", "jsonc", "cjson" },
    { commentstring = "// %s" },
  },

  { "asm", { tabstop = 8 } },

  { "help", { conceallevel = 0 } },

  { "graphql", { commentstring = "# %s" } },

  {
    { "dosini", "confini", "jess" },
    { commentstring = "; %s" },
  },

  -- {
  --   { "python" },
  --   { indentexpr = "nvim_treesitter#indent()" },
  -- },

  {
    "hocon",
    { commentstring = "# %s", cindent = true, cinoptions = "+0" },
  },

  { "erlang", { expandtab = true, shiftwidth = 4 } },

  { { "c", "sh", "bash" }, { keywordprg = ":Man" } },
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
