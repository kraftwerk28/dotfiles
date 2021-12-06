local enabled_linux = {
  "bash",
  "c",
  "c_sharp",
  "comment",
  "cpp",
  "css",
  "elm",
  "erlang",
  "go",
  "graphql",
  "html",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "kotlin",
  "latex",
  "lua",
  "python",
  "regex",
  "ruby",
  "rust",
  "scss",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  -- "yaml",
  -- "haskell",
}

local enabled_windows = {
  "java",
  "kotlin",
  "javascript",
  "lua",
}

local ensure_installed

if vim.fn.has("unix") == 1 then
  ensure_installed = enabled_linux
elseif vim.fn.has("win64") == 1 then
  ensure_installed = enabled_windows
else
  error("tree_sitter.lua: Unsupported OS")
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.bash.used_by = {"zsh", "PKGBUILD"}

require("nvim-treesitter.configs").setup {
  ensure_installed = ensure_installed,
  highlight = {
    enable = true,
  },
  playground = {
    enable = true,
    updatetime = 25,
    persist_queries = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>)",
      node_incremental = ")",
      node_decremental = "(",
    },
  },
  -- indent = {enable = true},
}
