local cmp = require("cmp")

local M = {}

-- Copied from https://github.com/davidsierradz/cmp-conventionalcommits/blob/master/lua/cmp-conventionalcommits/init.lua#L3
local summary = {
  build = {
    label = "build",
    documentation = "Changes that affect the build system or external dependencies",
  },
  chore = {
    label = "chore",
    documentation = "Other changes that dont modify src or test files",
  },
  ci = {
    label = "ci",
    documentation = "Changes to our CI configuration files and scripts",
  },
  docs = {
    label = "docs",
    documentation = "Documentation only changes",
  },
  feat = { label = "feat", documentation = "A new feature" },
  fix = { label = "fix", documentation = "A bug fix" },
  perf = {
    label = "perf",
    documentation = "A code change that improves performance",
  },
  refactor = {
    label = "refactor",
    documentation = "A code change that neither fixes a bug nor adds a feature",
  },
  revert = {
    label = "revert",
    documentation = "Reverts a previous commit",
  },
  style = {
    label = "style",
    documentation = "Changes that do not affect the meaning of the code",
  },
  test = {
    label = "test",
    documentation = "Adding missing tests or correcting existing tests",
  },
}

local completion_list = vim.tbl_map(function(item)
  local item2 = vim.deepcopy(item)
  item2.kind = cmp.lsp.CompletionItemKind.Constant
  return item2
end, vim.tbl_values(summary))

function M:complete(params, callback)
  if params.context.filetype == "gitcommit" then
    return callback(completion_list)
  end
  callback()
end

return M
