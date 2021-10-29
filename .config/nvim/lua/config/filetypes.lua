local api = vim.api
local utils = require"config.utils"

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
  vim.cmd[[augroup filetype_options]]
  vim.cmd[[autocmd!]]
  for _, cfg in ipairs(ftconfig) do
    local filetypes, opts = cfg[1], cfg[2]
    local function apply_opts()
      for name, value in pairs(opts) do
        vim.bo[name] = value
      end
    end
    vim.cmd(([[autocmd Filetype %s call v:lua.%s()]]):format(
      table.concat(filetypes, ","),
      utils.defglobalfn(apply_opts)
    ))
  end
  vim.cmd[[augroup END]]
end
