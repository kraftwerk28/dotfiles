local api = vim.api

vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    glsl = "frag",
    frag = "glsl",
    mjml = "html",
    ejs = "html",
    bnf = "bnf",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
    [".eslintrc"] = "json",
  },
  pattern = {
    ["^%.env%."] = "sh",
    ["%.webmanifest$"] = "json",
  },
})

-- filetype -> list of patterns that match it
-- local additional_filetypes = {
--   zsh = {"*.zsh*"},
--   sh = {".env.*"},
--   bnf = {"*.bnf"},
--   json = {"*.webmanifest", ".eslintrc"},
--   jsonc = {"tsconfig.json"},
--   rest = {"*.http"},
--   elixir = {"*.exs", "*.ex"},
--   prolog = {"*pl"},
--   html = {"*.ejs", "*.mjml"},
--   glsl = {"*.{vert,frag}"},
-- }

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

  -- { {"markdown"},
  --   { conceallevel = 2 }},

  { { "graphql" }, { commentstring = "# %s" } },
}

return function()
  -- local ftgroup = api.nvim_create_augroup("extra_filetypes", {})
  -- for ft, patterns in pairs(additional_filetypes) do
  --   api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  --     pattern = patterns,
  --     callback = function() vim.bo.filetype = ft end,
  --     group = ftgroup,
  --   })
  -- end

  local optgroup = api.nvim_create_augroup("filetype_opts", {})
  for _, cfg in ipairs(ftconfig) do
    local filetypes, opts = cfg[1], cfg[2]
    api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        for name, value in pairs(opts) do
          vim.o[name] = value
        end
      end,
      group = optgroup,
    })
  end

  local qclose_group = vim.api.nvim_create_augroup("aux_win_close", {})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man", "qf", "fugitive" },
    callback = function()
      vim.keymap.set("n", "<Esc>", "<Cmd>:bdelete<CR>", {
        buffer = true,
        silent = true,
      })
    end,
    group = qclose_group,
  })
end
