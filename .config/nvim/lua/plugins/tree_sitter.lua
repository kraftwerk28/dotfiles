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
  "markdown",

  "norg",
  "norg_meta",
  "norg_table",
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

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

-- parser_configs.bash.used_by = {"zsh", "PKGBUILD"}

-- Neorg parsers
parser_configs.norg = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg",
    files = {"src/parser.c", "src/scanner.cc"},
    branch = "main"
  },
}
parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = {"src/parser.c"},
    branch = "main"
  },
}
parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = {"src/parser.c"},
    branch = "main"
  },
}


require("nvim-treesitter.configs").setup {
  -- ...
  textobjects = {
    -- ...
    move = {
      enable = true,
      goto_previous_start = {
        ["[b"] = "@block.inner",
      },
    },
  },
}

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
      goto_previous_start = {
        ["[b"] = "@block.outer",
      },
    },
  },
}
