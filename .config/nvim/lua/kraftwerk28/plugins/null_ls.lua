local b = require("null-ls.builtins")
local u = require("null-ls.utils")
local h = require("null-ls.helpers")
local m = require("null-ls.methods")
local sev = h.diagnostics.severities

local hoogle_hover = h.make_builtin({
  name = "hoogle-search",
  method = m.internal.HOVER,
  filetypes = { "haskell" },
  generator = {
    fn = function(_, done)
      local cword = vim.fn.expand("<cword>")
      require("plenary.curl").request({
        url = "https://hoogle.haskell.org?mode=json&count=1&hoogle=" .. cword,
        method = "get",
        callback = vim.schedule_wrap(function(data)
          if not (data and data.body) then
            done({ "no definition available" })
            return
          end
          local ok, decoded = pcall(vim.json.decode, data.body)
          if not ok or not (decoded and decoded[1]) then
            done({ "no definition available" })
            return
          end
          local item = decoded[1]
          local title = item.item
            :gsub("</?span[^>]*>", "")
            :gsub("</?b>", "**")
            :gsub("</?s0>", "_")
          local body = item.docs:gsub("</?%w+>", "")
          local misc = ("**Module**: [%s](%s)"):format(
            item.module.name,
            item.module.url
          )
          local more = ("**More**: %s"):format(item.url)
          done({ title, body, misc, more })
        end),
      })
    end,
    async = true,
  },
})

local porth_diagnostic = h.make_builtin({
  name = "porth-diagnostic",
  filetypes = { "porth" },
  method = m.internal.DIAGNOSTICS,
  generator_opts = {
    command = vim.env.HOME .. "/projects/porth/porth",
    args = function(p)
      return { "com", p.temp_path }
    end,
    from_stderr = true,
    format = "line",
    to_temp_file = true,
    on_output = h.diagnostics.from_pattern(
      [[(%d+):(%d+): (%w+): (.*)]],
      { "row", "col", "severity", "message" },
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
})

local jq_format = h.make_builtin({
  name = "jq",
  method = m.internal.FORMATTING,
  filetypes = { "json" },
  generator_opts = {
    command = "jq",
    args = { "-M", "." },
    to_stdin = true,
  },
  factory = h.formatter_factory,
})

require("null-ls").setup({
  fallback_severity = vim.diagnostic.severity.WARN,
  sources = {
    b.diagnostics.eslint_d,
    b.formatting.eslint_d.with({
      timeout = 10000,
    }),
    b.code_actions.eslint_d,
    b.formatting.prettier.with({
      filetypes = { "graphql" },
    }),

    b.diagnostics.luacheck.with({
      args = vim.tbl_flatten({
        "--formatter",
        "plain",
        "--codes",
        "--ranges",
        "--globals",
        -- See lua/kraftwerk28/globals.lua
        { "vim", "o", "lo", "go", "m", "au", "aug" },
        "--filename",
        "$FILENAME",
        "-",
      }),
    }),
    b.formatting.stylua,

    b.diagnostics.shellcheck.with({
      condition = function()
        return vim.fn.expand("%:t") ~= "PKGBUILD"
      end,
    }),
    b.code_actions.shellcheck.with({
      condition = function()
        return vim.fn.expand("%:t") ~= "PKGBUILD"
      end,
    }),

    porth_diagnostic,
    jq_format,
    -- b.formatting.sqlformat,
    -- b.formatting.xmllint,
  },
})
