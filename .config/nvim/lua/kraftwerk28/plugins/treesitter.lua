-- do
--   local install_dir =
--     require("nvim-treesitter.configs").get_parser_install_dir()
--   local so_files = vim.split(vim.fn.glob(install_dir .. "/*.so"), "\n")
--   local existing = vim.tbl_map(function(it)
--     return vim.fn.fnamemodify(it, ":t:r")
--   end, so_files)
--   local redundant = vim.tbl_filter(function(lng)
--     return not vim.tbl_contains(ensure_installed, lng)
--   end, existing)
--   if #redundant > 0 then
--     require("nvim-treesitter.install").uninstall(redundant)
--   end
-- end

local config = {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>)",
      node_incremental = ")",
      node_decremental = "(",
    },
  },

  -- Third-party modules
  playground = {
    enable = true,
    updatetime = 25,
    persist_queries = false,
  },
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
      enable = true,
    },
  },
}

if vim.fn.has("unix") == 1 then
  config.ensure_installed = {
    "angular",
    "arduino",
    "awk",
    "bash",
    "c",
    "c_sharp",
    "cmake",
    "comment",
    "commonlisp",
    "cpp",
    "css",
    "csv",
    "cuda",
    "d",
    "dart",
    "diff",
    "dockerfile",
    "dot",
    "ebnf",
    "elixir",
    "embedded_template",
    "erlang",
    "fennel",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "go",
    "gomod",
    "gosum",
    "graphql",
    "groovy",
    "hack",
    "haskell",
    "haskell_persistent",
    "hcl",
    "hlsl",
    "hocon",
    "html",
    "http",
    "java",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "jsonnet",
    "kconfig",
    "latex",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "matlab",
    "mermaid",
    "meson",
    "ninja",
    "nix",
    "objdump",
    "ocaml",
    "ocaml_interface",
    "pascal",
    "passwd",
    "pem",
    "perl",
    "php",
    "phpdoc",
    "promql",
    "properties",
    "pug",
    "pymanifest",
    "python",
    "query",
    "rasi",
    "regex",
    "requirements",
    "ruby",
    "rust",
    "scheme",
    "scss",
    "sql",
    "ssh_config",
    "strace",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "v",
    "vala",
    "verilog",
    "vim",
    "vimdoc",
    "vue",
    "xml",
    "yaml",
    "zig",
  }
end

if vim.fn.has("win64") == 1 then
  config.ensure_installed = {
    "java",
    "kotlin",
    "javascript",
    "lua",
    "python",
  }
end

-- Enable nvim-treesitter's folding
-- vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.o.foldenable = false

require("nvim-treesitter.configs").setup(config)
