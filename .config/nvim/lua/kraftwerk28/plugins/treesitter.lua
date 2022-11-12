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

-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

-- local ts_cms = require("ts_context_commentstring.internal")
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = ts_cms.update_commentstring,
-- })

local config = {
  -- ensure_installed = ensure_installed,
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
    enable = false,
    enable_autocmd = false,
  },
}

if vim.fn.has("unix") == 1 then
  config.ensure_installed = "all"
  config.ignore_install = {
    "beancount",
    "bibtex",
    "cooklang",
    "dockerfile",
    "elvish",
    "foam",
    "fusion",
    "gleam",
    "glimmer",
    "heex",
    "lalrpop",
    "pioasm",
    "slint",
    "sql",
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

require("nvim-treesitter.configs").setup(config)
