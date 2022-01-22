local utils = require"config.utils"

-- filetype -> list of patterns that match it
local additional_filetypes = {
  zsh = {"*.zsh*"},
  sh = {".env.*"},
  bnf = {"*.bnf"},
  json = {"*.webmanifest", ".eslintrc"},
  jsonc = {"tsconfig.json"},
  rest = {"*.http"},
  elixir = {"*.exs", "*.ex"},
  prolog = {"*pl"},
  html = {"*.ejs", "*.mjml"},
}

-- Set options for filetypes
local ftconfig = {
  {{"go", "make", "c", "cpp"},
   {shiftwidth = 4, tabstop = 4, expandtab = false}},
  {{"java", "kotlin", "groovy", "csharp", "cabal", "python"},
   {shiftwidth = 4, tabstop = 4, expandtab = true}},
  {{"javascript", "typescript", "javascriptreact",
    "typescriptreact", "svelte",
    "json", "vim", "yaml", "haskell", "lisp", "lua", "graphql"},
   {shiftwidth = 2, tabstop = 2, expandtab = true}},
  {{"jess"},
   {commentstring = "; %s"}},
  {{"json", "jsonc", "cjson"},
   {commentstring = "// %s" }},
  {{"asm"},
   {shiftwidth = 8, tabstop=8, expandtab = false}},
}

return function()
  vim.cmd "augroup extra_filetypes"
  vim.cmd "autocmd!"
  for ft, patterns in pairs(additional_filetypes) do
    local p = table.concat(patterns, ",")
    vim.cmd(("autocmd BufNewFile,BufRead %s setlocal ft=%s"):format(p, ft))
  end
  vim.cmd "augroup END"

  vim.cmd "augroup extra_filetypes"
  vim.cmd "autocmd!"
  for _, cfg in ipairs(ftconfig) do
    local filetypes, opts = unpack(cfg)
    local fn = utils.defglobalfn(function()
      for name, value in pairs(opts) do
        print(("%s => %s"):format(name, value))
        vim.bo[name] = value
      end
    end)
    local p = table.concat(filetypes, ",")
    vim.cmd(("autocmd Filetype %s call v:lua.%s()"):format(p , fn))
  end
  vim.cmd "augroup END"
end
