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
  {{"go", "make", "c", "cpp", "python"},
   {shiftwidth = 4, tabstop = 4, expandtab = false}},
  {{"java", "kotlin", "groovy", "csharp", "cabal"},
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
  vim.cmd[[augroup extra_filetypes]]
  vim.cmd[[autocmd!]]
  for ft, patterns in pairs(additional_filetypes) do
    vim.cmd(([[autocmd BufNewFile,BufRead %s setlocal ft=%s]]):format(
      table.concat(patterns, ","),
      ft
    ))
  end
  vim.cmd[[augroup END]]

  vim.cmd[[augroup filetype_options]]
  vim.cmd[[autocmd!]]
  for _, cfg in ipairs(ftconfig) do
    local filetypes, opts = cfg[1], cfg[2]
    vim.cmd(([[autocmd Filetype %s call v:lua.%s()]]):format(
      table.concat(filetypes, ","),
      utils.defglobalfn(function()
        for name, value in pairs(opts) do
          vim.bo[name] = value
        end
      end)
    ))
  end
  vim.cmd[[augroup END]]
end
