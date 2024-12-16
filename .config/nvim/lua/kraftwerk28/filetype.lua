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
  -- Indentation options
  {
    {
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
    { expandtab = false, shiftwidth = 0 },
  },
  {
    {
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
    { expandtab = true, shiftwidth = 4 },
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
      "vue",
    },
    { expandtab = true, shiftwidth = 2 },
  },
  { "asm", { expandtab = false, tabstop = 8, shiftwidth = 0 } },

  -- Misc options
  {
    { "json", "jsonc", "cjson" },
    { commentstring = "// %s" },
  },
  { "help", { conceallevel = 0 } },
  { "graphql", { commentstring = "# %s" } },
  {
    { "dosini", "confini", "jess" },
    { commentstring = "; %s" },
  },
  {
    "hocon",
    { commentstring = "# %s", cindent = true, cinoptions = "+0" },
  },

  {
    { "c", "sh", "bash" },
    { keywordprg = ":Man" },
  },

  { { "sml" }, { commentstring = "(* %s *)" } },

  { { "markdown" }, { breakindent = true } },
}

local filetype_opts = augroup("filetype_opts")
for _, cfg in ipairs(ftconfig) do
  local filetypes, opts = cfg[1], cfg[2]
  autocmd("FileType", {
    pattern = filetypes,
    callback = function()
      for name, value in pairs(opts) do
        setlocal[name] = value
      end
    end,
    group = filetype_opts,
  })
end

autocmd("FileType", {
  pattern = { "help", "qf", "fugitive", "git", "fugitiveblame" },
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", {
      buffer = true,
      silent = true,
    })
  end,
  group = augroup("aux_win_close"),
})
