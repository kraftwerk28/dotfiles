local b = require("null-ls.builtins")
local u = require("null-ls.utils")
local h = require("null-ls.helpers")
local m = require("null-ls.methods")

local iwyu_diagnostics = h.make_builtin {
  name = "include-what-you-use",
  filetypes = {"cpp", "c"},
  method = m.internal.DIAGNOSTICS,
  generator_opts = {
    -- command = "include-what-you-use",
    -- args = {"$FILENAME"},
    command = "iwyu-tool",
    args = function(params)
      return {
        "-o", "clang",
        "-p", params.root.."/compile_commands.json",
        "$FILENAME",
      }
    end,
    -- from_stderr = true,
    on_output = function(params, done)
      if not params.output then
        return done()
      end
      local lines = vim.split(params.output, "\n")
      local is_add, is_remove = false, false
      local diagnostics = {}
      for _, line in ipairs(lines) do
        if line:match("should add these lines") then
          is_add = true
        elseif line:match("should remove these lines") then
          is_remove = true
        elseif line == "" then
          is_add = false
          is_remove = false
        elseif is_add then
          local include_stmt = vim.trim(line:match("^(.+)//"))
          table.insert(diagnostics, {
            message = "Add `" .. include_stmt .. "`",
            source = "iwyu",
            severity = 2,
          })
        elseif is_remove then
          local line_start, line_end = line:match("lines%s+(%d+)-(%d+)%s*$")
          table.insert(diagnostics, {
            row = tonumber(line_start),
            end_row = tonumber(line_end) + 1,
            message = "Remove this `#include`",
            source = "iwyu",
            severity = 2,
          })
        end
      end
      done(diagnostics)
    end
    -- format = "line",
    -- on_output = h.diagnostics.from_pattern(
    --   [[(%d+):(%d+): (%w+): (.+)]],
    --   {"row", "col", "severity", "message"}
    -- ),
  },
  factory = h.generator_factory,
}

local iwyu_format = h.make_builtin {
  filetypes = {"cpp", "c"},
  method = m.internal.FORMATTING,
  generator_opts = {
    name = "iwyu-fix-includes",
    command = "sh",
    args = function(params)
      local cmd =
        ("iwyu-tool -p %s/compile_commands.json %s | iwyu-fix-includes")
          :format(params.root, params.bufname)
      return {"-c", cmd}
    end,
    to_temp_file = true,
    check_exit_code = {1},
    -- from_stderr = true,
    -- on_output = on_iwyu_output,
    -- format = "line",
    -- on_output = h.diagnostics.from_pattern(
    --   [[(%d+):(%d+): (%w+): (.+)]],
    --   {"row", "col", "severity", "message"}
    -- ),
    -- on_output = function()
    --   return {title = "Fix includes", action = iwyu_fix_includes}
    -- end,
  },
  factory = h.formatter_factory,
}

require("null-ls").setup {
  sources = {
    b.diagnostics.eslint_d,
    b.formatting.eslint_d,
    b.diagnostics.luacheck.with {
      args = {
        "--formatter", "plain",
        "--codes",
        "--ranges",
        "--globals", "vim",
        "--filename", "$FILENAME",
        "-",
      },
    },
    b.hover.dictionary.with {
      filetypes = {"markdown"},
    },
    b.formatting.prettier.with {
      filetypes = {"graphql"},
    },
    b.code_actions.eslint_d,
    b.diagnostics.shellcheck,
    b.code_actions.shellcheck,
  },
  root_dir = u.root_pattern(
    ".null-ls-root",
    "Makefile",
    ".git",
    ".eslintrc*"
  ),
}