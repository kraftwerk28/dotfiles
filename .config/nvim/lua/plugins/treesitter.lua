local enabled_linux = {
  "bash",
  -- "beancount",
  -- "bibtex",
  "c",
  "c_sharp",
  "clojure",
  "cmake",
  "comment",
  "commonlisp",
  -- "cooklang",
  "cpp",
  "css",
  "cuda",
  "d",
  "dart",
  "devicetree",
  -- "dockerfile",
  "dot",
  "eex",
  "elixir",
  "elm",
  -- "elvish",
  "fennel",
  "fish",
  -- "foam",
  "fortran",
  -- "fusion",
  "gdscript",
  -- "gleam",
  -- "glimmer",
  "glsl",
  "go",
  "godot_resource",
  "gomod",
  "gowork",
  "graphql",
  "hack",
  "haskell",
  "hcl",
  -- "heex",
  "help",
  "hjson",
  -- "hocon",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "julia",
  "kotlin",
  -- "lalrpop",
  "latex",
  "ledger",
  "llvm",
  "lua",
  "make",
  "markdown",
  "ninja",
  "nix",
  "ocaml",
  "ocaml_interface",
  "ocamllex",
  "pascal",
  "perl",
  "php",
  "phpdoc",
  -- "pioasm",
  "prisma",
  "pug",
  "python",
  "ql",
  "query",
  "r",
  "rasi",
  "regex",
  "rego",
  "rst",
  "ruby",
  "rust",
  "scala",
  "scheme",
  "scss",
  -- "slint",
  "solidity",
  "sparql",
  "supercollider",
  "surface",
  "svelte",
  "swift",
  "teal",
  "tlaplus",
  "todotxt",
  "toml",
  "tsx",
  "turtle",
  "typescript",
  "vala",
  "verilog",
  -- "vim",
  "vue",
  "yaml",
  "yang",
  "zig",
}

local enabled_windows = {
  "java",
  "kotlin",
  "javascript",
  "lua",
  "python",
}

local ensure_installed
if vim.fn.has("unix") == 1 then
  ensure_installed = enabled_linux
elseif vim.fn.has("win64") == 1 then
  ensure_installed = enabled_windows
end

do
  local install_dir = require("nvim-treesitter.configs").get_parser_install_dir()
  local so_files = vim.split(vim.fn.glob(install_dir .. "/*.so"), "\n")
  local existing = vim.tbl_map(function(it)
    return vim.fn.fnamemodify(it, ":t:r")
  end, so_files)
  local redundant = vim.tbl_filter(function(lng)
    return not vim.tbl_contains(ensure_installed, lng)
  end, existing)
  if #redundant > 0 then
    require("nvim-treesitter.install").uninstall(redundant)
  end
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

-- parser_configs.bash.used_by = {"zsh", "PKGBUILD"}

-- do
--   local rev = "0ef3e2ad9b9e066b0900bff992b1fcb48975882d"
--   local url = "https://github.com/kraftwerk28/tree-sitter-typescript"
--   parser_configs.typescript.install_info.url = url
--   parser_configs.typescript.install_info.revision = rev
--   parser_configs.tsx.install_info.url = url
--   parser_configs.tsx.install_info.revision = rev
-- end

-- do
--   local url = "/home/kraftwerk28/projects/tree-sitter/tree-sitter-c"
--   parser_configs.c.url = url
-- end

do
  -- Neorg parsers
  parser_configs.norg = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
    },
  }
  parser_configs.norg_meta = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
      files = { "src/parser.c" },
      branch = "main",
    },
  }
  parser_configs.norg_table = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
      files = { "src/parser.c" },
      branch = "main",
    },
  }
end

local ts_cms = require("ts_context_commentstring.internal")
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = ts_cms.update_commentstring,
})

require("nvim-treesitter.configs").setup({
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
  -- indent = {
  --   enable = true,
  -- },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      lookbehind = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
      },
    },
    move = {
      enable = false,
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})
