local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local root_pattern = require("lspconfig.util").root_pattern
local cmp_lsp = require("cmp_nvim_lsp")

local fn = vim.fn

local function make_cpb()
  return cmp_lsp.default_capabilities()
end

local function find_compile_commands()
  local ccj = fn.glob("compile_commands.json", nil, true)
  if #ccj == 0 then
    ccj = fn.glob("build/compile_commands.json", nil, true)
  end
  if #ccj == 0 then
    return
  end
  return fn.fnamemodify(ccj[1], ":p:h")
end

if not configs.mesonls then
  configs.mesonls = {
    default_config = {
      cmd = { "/home/kraftwerk28/projects/meson/mesonls/__main__.py" },
      filetypes = { "meson" },
      root_dir = root_pattern({ "meson.build" }),
      settings = {},
    },
  }
end

-- lspconfig.mesonls.setup({})

lspconfig.als.setup({
  capabilities = make_cpb(),
})

lspconfig.arduino_language_server.setup({
  cmd = {
    "arduino-language-server",
    "-clangd",
    fn.exepath("clangd"),
    "-cli",
    fn.exepath("arduino-cli"),
    "-cli-config",
    fn.expand("~/.arduino15/arduino-cli.yaml"),
  },
})

lspconfig.awk_ls.setup({
  capabilities = make_cpb(),
})

lspconfig.denols.setup({
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
  capabilities = make_cpb(),
})

lspconfig.gopls.setup({
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        update_in_insert = true,
        virtual_text = { spacing = 2, prefix = "" },
      }
    ),
  },
  capabilities = make_cpb(),
})

lspconfig.graphql.setup({ capabilities = make_cpb() })

lspconfig.hls.setup({
  settings = {
    haskell = {
      formattingProvider = "brittany",
    },
  },
  capabilities = make_cpb(),
})

lspconfig.pylsp.setup({
  capabilities = make_cpb(),
})

lspconfig.rust_analyzer.setup({
  capabilities = make_cpb(),
})

lspconfig.tsserver.setup({
  on_attach = function(client)
    local c = client.server_capabilities
    -- Formatting is handled by prettier through null-ls
    c.documentFormattingProvider = false
    c.documentRangeFormattingProvider = false
  end,
  capabilities = make_cpb(),
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
    },
  },
})

-- lspconfig.flow.setup {
--   cmd = {'flow', 'lsp'},
--   filetypes = {'javascript', 'javascriptreact'},
--   root_dir = root_pattern('.flowconfig'),
-- }

-- lspconfig.pyre.setup {
--   root_dir = root_pattern {
--     ".git",
--   },
-- }

-- lspconfig.pyright.setup {}

-- lspconfig.sumneko_lua.setup {
--   cmd = {
--     "lua-language-server",
--     "-E", "/usr/share/lua-language-server/main.lua",
--     "--logpath",
--     vim.lsp.get_log_path():match("(.*[/\\])"),
--   },
--   settings = {
--     Lua = {
--       runtime = {
--         version = "LuaJIT",
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         globals = {"vim", "love"},
--       },
--       workspace = {
--         library = {
--           [fn.expand("$VIMRUNTIME/lua")] = true,
--           [fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--         },
--       },
--     },
--   },
-- }

do
  local cmd = { "clangd", "--background-index" }
  local ccj = find_compile_commands()
  if ccj then
    table.insert(cmd, "--compile-commands-dir")
    table.insert(cmd, ccj)
  end
  local cpb = make_cpb()
  cpb.offsetEncoding = { "utf-16" }
  lspconfig.clangd.setup({
    cmd = cmd,
    root_dir = root_pattern({
      "CMakeLists.txt",
      "meson.build",
      "meson_options.txt",
      ".git",
    }),
    capabilities = cpb,
  })
end

lspconfig.svelte.setup({
  capabilities = make_cpb(),
})

lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = {
        enable = true,
      },
    },
  },
  capabilities = make_cpb(),
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      format = {
        enable = true,
        singleQuote = false,
      },
      hover = true,
      completion = true,
      validate = true,
    },
  },
  capabilities = make_cpb(),
})

lspconfig.cssls.setup({
  capabilities = make_cpb(),
})

-- lspconfig.html.setup {
--   cmd = {"vscode-html-languageserver", "--stdio"}
-- }

-- lspconfig.bashls.setup {
--   filetypes = {"bash", "sh", "zsh"}
-- }

lspconfig.solargraph.setup({
  capabilities = make_cpb(),
})

-- lspconfig.emmet_ls.setup {}

lspconfig.erlangls.setup({
  capabilities = make_cpb(),
})

lspconfig.rescriptls.setup({
  cmd = { "rescript-ls", "--stdio" },
  capabilities = make_cpb(),
})

if fn.has("win64") == 1 then
  local jdt_base = fn.expand(
    "~/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
  )
  local java_home = fn.expand("C:/Program Files/Java/jdk-11.0.11")

  lspconfig.jdtls.setup({
    cmd = {
      fn.expand(java_home .. "/bin/java.exe"),
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1G",
      "-jar",
      fn.expand(
        jdt_base
          .. "/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar"
      ),
      "-configuration",
      fn.expand(jdt_base .. "/config_win"),
      "-data",
      fn.expand("~/Projects/jdt-ls-data"),
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
    },
    filetypes = { "java" },
    root_dir = root_pattern({ ".git", "build.gradle", "build.gradle.kts" }),
  })

  lspconfig.groovyls.setup({
    cmd = {
      "java",
      "-jar",
      fn.expand(
        "~/Projects/groovy-language-server"
          .. "/build/libs/groovy-language-server-all.jar"
      ),
    },
  })
end

-- do
--   -- OBSOLETTE: kotlin is still much better with Jetbrains Idea...
--   local cmd, cmd_env
--   if fn.has("win64") == 1 then
--     cmd = {
--       fn.expand(
--         "~/Projects/kotlin-language-server/server/build/install"
--           .. "/server/bin/kotlin-language-server.bat"
--       ),
--     }
--   end
--   if fn.has("unix") == 1 then
--     local jdk_home = "/usr/lib/jvm/java-11-openjdk"
--     cmd_env = {
--       PATH = jdk_home .. "/bin:" .. vim.env.PATH,
--       JAVA_HOME = jdk_home,
--     }
--   end
--   lspconfig.kotlin_language_server.setup({
--     cmd = cmd,
--     cmd_env = cmd_env,
--     settings = { kotlin = { compiler = { jvm = { target = "1.8" } } } },
--     root_dir = root_pattern({ "build.gradle", "build.gradle.kts" }),
--     capabilities = make_cpb(),
--   })
-- end
