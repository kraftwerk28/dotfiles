local b = require("null-ls.builtins")
local u = require("null-ls.utils")
local h = require("null-ls.helpers")
local m = require("null-ls.methods")
local sev = h.diagnostics.severities

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
      return {
        "-c",
        ("iwyu-tool -p %s/compile_commands.json %s | iwyu-fix-includes")
          :format(params.temp_path, params.root, params.temp_path),
          -- :format(params.root, params.bufname),
      }
    end,
    to_temp_file = true,
    from_temp_file = true,
    check_exit_code = function() return true end,
  },
  factory = h.formatter_factory,
}

local hoogle_hover = h.make_builtin {
  name = "hoogle-search",
  method = m.internal.HOVER,
  filetypes = {"haskell"},
  generator = {
    fn = function(_, done)
      local cword = vim.fn.expand("<cword>")
      require("plenary.curl").request({
        url = "https://hoogle.haskell.org?mode=json&count=1&hoogle=" .. cword,
        method = "get",
        callback = vim.schedule_wrap(function(data)
          if not (data and data.body) then
            done {"no definition available"}
            return
          end
          local ok, decoded = pcall(vim.json.decode, data.body)
          if not ok or not (decoded and decoded[1]) then
            done {"no definition available"}
            return
          end
          local item = decoded[1]
          local title = item.item
            :gsub("</?span[^>]*>", "")
            :gsub("</?b>", "**")
            :gsub("</?s0>", "_")
          local body = item.docs:gsub("</?%w+>", "")
          local misc = ("**Module**: [%s](%s)")
            :format(item.module.name, item.module.url)
          local more = ("**More**: %s"):format(item.url)
          done {title, body, misc, more}
        end),
      })
    end,
    async = true,
  },
}

local porth_diagnostic = h.make_builtin {
  name = "porth-diagnostic",
  filetypes = {"porth"},
  method = m.internal.DIAGNOSTICS,
  generator_opts = {
    command = vim.env.HOME.."/projects/porth/porth",
    args = function(p)
      return {"com", p.temp_path}
    end,
    from_stderr = true,
    format = "line",
    to_temp_file = true,
    on_output = h.diagnostics.from_pattern(
      [[(%d+):(%d+): (%w+): (.*)]],
      {"row", "col", "severity", "message"},
      {
        severities = {
          ERROR = sev.error,
          NOTE = sev.hint,
          DEBUG = sev.information,
        },
      }
    ),
  },
  factory = h.generator_factory,
}

require("null-ls").setup {
  sources = {
    b.diagnostics.eslint_d.with {
      cwd = function(params)
        return u.root_pattern(".eslintrc*")(params.bufname)
      end
    },
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
    b.diagnostics.shellcheck.with {
      filetypes = {"sh", "PKGBUILD"},
    },
    b.code_actions.shellcheck.with {
      filetypes = {"sh", "PKGBUILD"},
    },
    -- hoogle_hover,
    -- iwyu_format,
    porth_diagnostic,
  },
}
