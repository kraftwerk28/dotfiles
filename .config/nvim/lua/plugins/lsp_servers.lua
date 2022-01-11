local lsp_config = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern

local lsp, fn = vim.lsp, vim.fn
local expand = fn.expand

lsp_config.als.setup {}

lsp_config.tsserver.setup {
  cmd = {"typescript-language-server", "--stdio"},
  root_dir = root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    fn.getcwd()
  ),
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

lsp_config.graphql.setup {
  cmd = {"graphql-lsp", "server", "--method=stream"},
}

lsp_config.denols.setup {
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
  root_dir = root_pattern("deno.json"),
}

-- lsp_config.flow.setup {
--   cmd = {'flow', 'lsp'},
--   filetypes = {'javascript', 'javascriptreact'},
--   root_dir = root_pattern('.flowconfig'),
-- }

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

-- lsp_config.pyre.setup {
--   root_dir = root_pattern(
--     ".git",
--     fn.getcwd()
--   ),
-- }

lsp_config.pylsp.setup {
  cmd = {"pyls"},
  filetypes = {"python"},
  -- settings = {pyls = pyls_settings},
}

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
--           [expand("$VIMRUNTIME/lua")] = true,
--           [expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--         },
--       },
--     },
--   },
-- }

do
  local cpb = lsp.protocol.make_client_capabilities()
  cpb = require("cmp_nvim_lsp").update_capabilities(cpb)
  -- cpb.textDocument.completion.completionItem.snippetSupport = true
  lsp_config.rust_analyzer.setup {
    capabilities = cpb,
  }
end

lsp_config.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = function(name)
    return root_pattern("go.mod", ".git")(name) or fn.getcwd()
  end,
}

lsp_config.hls.setup {
  settings = {haskell = {formattingProvider = "brittany"}},
  root_dir = root_pattern(
    "*.cabal",
    "stack.yaml",
    "cabal.project",
    "package.yaml",
    "hie.yaml",
    fn.getcwd()
  ),
}

do
  local clangdcmd = {"clangd", "--background-index"}
  if fn.glob("build/compile_commands.json") ~= "" then
    vim.tbl_extend("force", clangdcmd, {"--compile-commands-dir", "build"})
  end
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = {"utf-16"}
  lsp_config.clangd.setup {
    cmd = clangdcmd,
    filetypes = {"c", "cpp", "objc", "objcpp"},
    root_dir = root_pattern(
      "CMakeLists.txt",
      "compile_flags.txt",
      ".git",
      fn.getcwd()
    ),
    capabilities = capabilities,
  }
end

lsp_config.svelte.setup {}

do
  local schemas = {
    {
      fileMatch = {"tsconfig.json", "tsconfig.*.json"},
      url = "http://json.schemastore.org/tsconfig",
    },
    {
      fileMatch = {"jsconfig.json", "jsconfig.*.json"},
      url = "http://json.schemastore.org/jsconfig",
    },
    {
      fileMatch = {".eslintrc*"},
      url = "http://json.schemastore.org/eslintrc",
    },
    {
      fileMatch = {".babelrc*"},
      url = "http://json.schemastore.org/babelrc",
    },
  }
  lsp_config.jsonls.setup {
    cmd = {"vscode-json-languageserver", "--stdio"},
    filetypes = {"json", "jsonc"},
    -- init_options = {provideFormatter = true},
    root_dir = root_pattern(".git", fn.getcwd()),
    settings = {json = {schemas = schemas}},
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

lsp_config.html.setup {
  cmd = {"vscode-html-languageserver", "--stdio"}
}

lsp_config.bashls.setup {filetypes = {"bash", "sh", "zsh"}}

lsp_config.solargraph.setup {}

-- lsp_config.emmet_ls.setup {}

if fn.has("win64") == 1 then
  local jdt_base = expand(
    "~/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
  )
  local java_home = expand("C:/Program Files/Java/jdk-11.0.11")

  lsp_config.jdtls.setup {
    cmd = {
      expand(java_home .. "/bin/java.exe"),
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1G",
      "-jar",
      expand(
        jdt_base ..
        "/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar"
      ),
      "-configuration",
      expand(jdt_base .. "/config_win"),
      "-data",
      expand("~/Projects/jdt-ls-data"),
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    },
    filetypes = {"java"},
    root_dir = root_pattern(".git", "build.gradle", "build.gradle.kts"),
  }

  lsp_config.groovyls.setup {
    cmd = {
      "java",
      "-jar",
      expand(
        "~/Projects/groovy-language-server" ..
        "/build/libs/groovy-language-server-all.jar"
      ),
    },
  }
end

do
  local cmd, cmd_env
  if fn.has("win64") == 1 then
    cmd = {
      expand(
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
    root_dir = root_pattern("build.gradle", "build.gradle.kts"),
  }
end

do
  local eslint_config = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m [%t%s/%s]"},
    lintIgnoreExitCode = true,
    formatCommand =
      "eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}",
    formatStdin = true,
  }
  local luacheck_config = {
    lintCommand = "luacheck - --no-color --no-self --globals vim",
    lintStdin = true,
    lintFormats = {"    %f:%l:%c: %m"},
    lintIgnoreExitCode = true,
  }
  -- local python_config = {
  --   formatCommand = "black --line-length 80 --stdin-filename ${INPUT} -",
  --   formatStdin = true,
  -- }
  local languages = {
    javascript      = {eslint_config},
    typescript      = {eslint_config},
    typescriptreact = {eslint_config},
    javascriptreact = {eslint_config},
    lua             = {luacheck_config},
  }
  -- lsp_config.efm.setup {
  --   filetypes = vim.tbl_keys(languages),
  --   init_options = {
  --     documentFormatting = true,
  --     hover = false,
  --     documentSymbol = false,
  --     codeAction = false,
  --     completion = false,
  --   },
  --   settings = {
  --     languages = languages,
  --   },
  --   root_dir = root_pattern(".eslintrc*", "init.lua", ".git"),
  -- }
end
