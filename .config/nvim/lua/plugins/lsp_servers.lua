local lsp_config = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern

local lsp, fn = vim.lsp, vim.fn
local make_cpb = vim.lsp.protocol.make_client_capabilities

local function find_compile_commands()
  local ccj = fn.glob("compile_commands.json", nil, true)
  if #ccj == 0 then
    ccj = fn.glob("build/compile_commands.json", nil, true)
  end
  if #ccj == 0 then return end
  return fn.fnamemodify(ccj[1], ":p:h")
end

lsp_config.als.setup {}

lsp_config.arduino_language_server.setup {
  cmd = {
    "arduino-language-server",
    "-clangd", fn.exepath("clangd"),
    "-cli", fn.exepath("arduino-cli"),
    "-cli-config", fn.expand("~/.arduino15/arduino-cli.yaml"),
  },
}

lsp_config.awk_ls.setup {}

lsp_config.denols.setup {
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
  root_dir = root_pattern {"deno.json"},
}

lsp_config.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = root_pattern {
    "go.mod",
    ".git",
    fn.getcwd(),
  },
}

lsp_config.graphql.setup {
  cmd = {"graphql-lsp", "server", "--method=stream"},
}

lsp_config.hls.setup {
  settings = {
    haskell = { formattingProvider = "brittany" },
  },
  root_dir = root_pattern {
    "*.cabal",
    "stack.yaml",
    "cabal.project",
    "package.yaml",
    "hie.yaml",
    fn.getcwd(),
  },
}

do
  -- local pyls_settings = {
  --   plugins = {
  --     jedi_completion = {enabled = true},
  --     jedi_hover = {enabled = true},
  --     jedi_references = {enabled = true},
  --     jedi_signature_help = {enabled = true},
  --     jedi_symbols = {enabled = true, all_scopes = true},
  --     yapf = {enabled = false},
  --     pylint = {enabled = false},
  --     pycodestyle = {enabled = false},
  --     pydocstyle = {enabled = false},
  --     mccabe = {enabled = false},
  --     preload = {enabled = false},
  --     rope_completion = {enabled = false},
  --     pyflakes = {enabled = false},
  --   },
  -- }
  lsp_config.pylsp.setup {}
end

do
  local cpb = lsp.protocol.make_client_capabilities()
  cpb = require("cmp_nvim_lsp").update_capabilities(cpb)
  cpb.textDocument.completion.completionItem.snippetSupport = false
  lsp_config.rust_analyzer.setup {
    -- capabilities = cpb,
  }
end

lsp_config.tsserver.setup {
  root_dir = root_pattern {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    fn.getcwd(),
  },
  initializationOptions = {
    preferences = {
      -- TODO: doesn't work
      -- importModuleSpecifierPreference = "relative",
      -- importModuleSpecifier = "relative",
    },
  },
  on_attach = function(client)
    -- Formatting is handled by null-ls
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
}

-- lsp_config.flow.setup {
--   cmd = {'flow', 'lsp'},
--   filetypes = {'javascript', 'javascriptreact'},
--   root_dir = root_pattern('.flowconfig'),
-- }

-- lsp_config.pyre.setup {
--   root_dir = root_pattern {
--     ".git",
--     fn.getcwd()
--   },
-- }

-- lsp_config.pyright.setup {}

-- lsp_config.sumneko_lua.setup {
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
--         globals = {"vim", "dump", "love"},
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
  local cmd = {"clangd", "--background-index"}
  local ccj = find_compile_commands()
  if ccj then
    table.insert(cmd, "--compile-commands-dir")
    table.insert(cmd, ccj)
  end
  local capabilities = make_cpb()
  capabilities.offsetEncoding = { "utf-16" }
  lsp_config.clangd.setup {
    cmd = cmd,
    root_dir = root_pattern {"CMakeLists.txt", ".git", fn.getcwd()},
    capabilities = capabilities,
  }
end

lsp_config.svelte.setup {}

do
  -- local schemas = {
  --   {
  --     fileMatch = {"tsconfig.json", "tsconfig.*.json"},
  --     url = "http://json.schemastore.org/tsconfig",
  --   },
  --   {
  --     fileMatch = {"jsconfig.json", "jsconfig.*.json"},
  --     url = "http://json.schemastore.org/jsconfig",
  --   },
  --   {
  --     fileMatch = {".eslintrc*"},
  --     url = "http://json.schemastore.org/eslintrc",
  --   },
  --   {
  --     fileMatch = {".babelrc*"},
  --     url = "http://json.schemastore.org/babelrc",
  --   },
  -- }
  local cpb = make_cpb()
  cpb.textDocument.completion.completionItem.snippetSupport = true
  lsp_config.jsonls.setup {
    cmd = {"vscode-json-languageserver", "--stdio"},
    -- init_options = {provideFormatter = true},
    -- settings = {
    --   json = { schemas = schemas },
    -- },
    capabilities = cpb,
  }
end

lsp_config.yamlls.setup {
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/json",
      },
      hover = true,
      completion = true,
    },
  },
}

lsp_config.cssls.setup {}

-- lsp_config.html.setup {
--   cmd = {"vscode-html-languageserver", "--stdio"}
-- }

lsp_config.bashls.setup {filetypes = {"bash", "sh", "zsh"}}

lsp_config.solargraph.setup {}

-- lsp_config.emmet_ls.setup {}

if fn.has("win64") == 1 then
  local jdt_base = fn.expand(
    "~/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
  )
  local java_home = fn.expand("C:/Program Files/Java/jdk-11.0.11")

  lsp_config.jdtls.setup {
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
        jdt_base ..
        "/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar"
      ),
      "-configuration",
      fn.expand(jdt_base .. "/config_win"),
      "-data",
      fn.expand("~/Projects/jdt-ls-data"),
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    },
    filetypes = {"java"},
    root_dir = root_pattern {".git", "build.gradle", "build.gradle.kts"},
  }

  lsp_config.groovyls.setup {
    cmd = {
      "java",
      "-jar",
      fn.expand(
        "~/Projects/groovy-language-server" ..
        "/build/libs/groovy-language-server-all.jar"
      ),
    },
  }
end

do
  -- OBSOLETTE: kotlin is much better with Jetbrains software...
  local cmd, cmd_env
  if fn.has("win64") == 1 then
    cmd = {
      fn.expand(
        "~/Projects/kotlin-language-server/server/build/install" ..
        "/server/bin/kotlin-language-server.bat"
      ),
    }
  end
  if fn.has("unix") == 1 then
    local jdk_home = "/usr/lib/jvm/java-11-openjdk"
    cmd_env = {
      PATH = jdk_home .. "/bin:" .. vim.env.PATH,
      JAVA_HOME = jdk_home,
    }
  end
  lsp_config.kotlin_language_server.setup {
    cmd = cmd,
    cmd_env = cmd_env,
    settings = {kotlin = {compiler = {jvm = {target = "1.8"}}}},
    root_dir = root_pattern {"build.gradle", "build.gradle.kts"},
  }
end
