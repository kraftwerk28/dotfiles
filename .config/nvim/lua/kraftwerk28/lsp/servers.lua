local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern
local cmp_lsp = require("cmp_nvim_lsp")

local fn = vim.fn

local function cmp_capabilities()
  return cmp_lsp.default_capabilities()
end

local function find_compile_commands()
  local ccj = fn.glob("compile_commands.json", nil, true)
  if #ccj == 0 then
    ccj = fn.glob("build/compile_commands.json", nil, true)
  else
    return
  end
  if #ccj == 0 then
    return
  end
  return fn.fnamemodify(ccj[1], ":p:h")
end

-- local configs = require("lspconfig.configs")
-- if configs.mesonls == nil then
--   configs.mesonls = {
--     default_config = {
--       cmd = { "/home/kraftwerk28/projects/meson/mesonls/__main__.py" },
--       filetypes = { "meson" },
--       root_dir = root_pattern({ "meson.build" }),
--       settings = {},
--     },
--   }
-- end

-- lspconfig.mesonls.setup({
--   capabilities = cmp_capabilities(),
-- })

lspconfig.als.setup({
  capabilities = cmp_capabilities(),
})

do
  local cmd = {
    "arduino-language-server",
    "-clangd=" .. vim.fn.exepath("clangd"),
    "-cli=" .. vim.fn.exepath("arduino-cli"),
    "-cli-config=" .. vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
  }
  local format_cfg = vim.fs.find(".clang-format", { upward = true })[1]
  if format_cfg then
    table.insert(cmd, "-format-conf-path=" .. format_cfg)
  end
  lspconfig.arduino_language_server.setup({
    cmd = cmd,
    -- NOTE: default capabilities are not empty, do not overwrite them
    -- capabilities = cmp_capabilities(),
  })
end

lspconfig.awk_ls.setup({
  capabilities = cmp_capabilities(),
})

lspconfig.denols.setup({
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
  capabilities = cmp_capabilities(),
})

lspconfig.gopls.setup({
  -- handlers = {
  --   ["textDocument/publishDiagnostics"] = vim.lsp.with(
  --     vim.lsp.diagnostic.on_publish_diagnostics,
  --     {
  --       update_in_insert = true,
  --       virtual_text = { spacing = 2, prefix = "" },
  --     }
  --   ),
  -- },
  capabilities = cmp_capabilities(),
})

lspconfig.graphql.setup({
  capabilities = cmp_capabilities(),
})

lspconfig.hls.setup({
  settings = {
    haskell = {
      -- formattingProvider = "brittany",
      formattingProvider = "ormolu",
    },
  },
  capabilities = cmp_capabilities(),
})

-- lspconfig.pylsp.setup({
--   capabilities = cmp_capabilities(),
--   on_attach = function(client)
--     -- Formatting is handled by black
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--   end,
-- })

lspconfig.pyright.setup({
  capabilities = cmp_capabilities(),
  on_attach = function(client)
    -- Formatting is handled by black
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  capabilities = cmp_capabilities(),
})

lspconfig.tsserver.setup({
  capabilities = cmp_capabilities(),
  init_options = {
    hostInfo = "neovim",
    plugins = {},
    preferences = {
      importModuleSpecifierPreference = "relative",
    },
    tsserver = {
      -- /**
      --  * Verbosity of the information logged into the `tsserver` log files.
      --  *
      --  * Log levels from least to most amount of details: `'terse'`, `'normal'`, `'requestTime`', `'verbose'`.
      --  * Enabling particular level also enables all lower levels.
      --  *
      --  * @default 'off'
      --  */
      -- logVerbosity = "verbose",
    },
  },
  on_attach = function(client, bufnr)
    -- Formatting is handled by null-ls (prettier)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    require("twoslash-queries").attach(client, bufnr)
  end,
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

-- do
--   local cmd = { "clangd", "--background-index" }
--   local ccj = find_compile_commands()
--   if ccj then
--     table.insert(cmd, "--compile-commands-dir=" .. ccj)
--   end
-- end

do
  local query_drivers = {
    host = "/usr/bin/{gcc,g++,c++,cpp}",
    stm32 = "/usr/bin/arm-none-eabi-{gcc,g++,c++,cpp}",
    esp32 = "/home/kraftwerk28/.espressif/tools/xtensa-esp32*-elf/*/*/bin/xtensa-esp32*-elf-{gcc,g++,c++,cpp}",
  }

  lspconfig.clangd.setup({
    cmd = {
      "clangd",
      "--background-index",
      "--header-insertion=never",
      "-j",
      "8",
      "--pch-storage=memory",
      -- "--query-driver=" .. table.concat(vim.tbl_values(query_drivers), ","),
    },
    capabilities = cmp_capabilities(),
    settings = {
      ["C_Cpp.dimInactiveRegions"] = false,
    },
    root_dir = root_pattern({
      "compile_commands.json",
      "build/compile_commands.json",
      "compile_flags.txt",
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "configure.ac",
      ".git",
    }),
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  })
end

lspconfig.svelte.setup({
  capabilities = cmp_capabilities(),
  settings = {
    svelte = {
      plugin = {
        typescript = {
          semanticTokens = { enable = false },
        },
      },
    },
  },
  on_attach = function(client)
    -- Formatting is handled by null-ls (prettier)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
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
  capabilities = cmp_capabilities(),
  on_attach = function(client)
    -- Formatting is handled by null-ls (jq)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
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
  capabilities = cmp_capabilities(),
})

lspconfig.cssls.setup({
  capabilities = cmp_capabilities(),
})

-- lspconfig.html.setup {
--   cmd = {"vscode-html-languageserver", "--stdio"}
-- }

-- lspconfig.bashls.setup {
--   filetypes = {"bash", "sh", "zsh"}
-- }

lspconfig.solargraph.setup({
  capabilities = cmp_capabilities(),
})

-- lspconfig.emmet_ls.setup {}

lspconfig.erlangls.setup({
  capabilities = cmp_capabilities(),
})

lspconfig.rescriptls.setup({
  cmd = { "rescript-ls", "--stdio" },
  capabilities = cmp_capabilities(),
})

lspconfig.volar.setup({
  capabilities = cmp_capabilities(),
  on_attach = function(client)
    -- Formatting is handled by null-ls (prettier)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

lspconfig.elmls.setup({})

lspconfig.tailwindcss.setup({
  filetypes = { "vue", "svelte" },
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
--     capabilities = cmp_capabilities(),
--   })
-- end
