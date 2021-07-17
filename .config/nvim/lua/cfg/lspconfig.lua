local utils = require("utils")
local lsp_config = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern

local lsp = vim.lsp
local highlight = utils.highlight
local u = utils.u
local expand = vim.fn.expand

highlight {"LspDiagnosticsUnderlineHint", gui = "undercurl"}
highlight {"LspDiagnosticsUnderlineInformation", gui = "undercurl"}
highlight {
  "LspDiagnosticsUnderlineWarning",
  gui = "undercurl",
  -- guisp = "Orange",
}
-- highlight {"LspDiagnosticsUnderlineError", gui = "undercurl", guisp = "Red"}
highlight {"LspDiagnosticsUnderlineError", gui = "undercurl"}

-- highlight {"LspDiagnosticsDefaultHint", fg = "Yellow"}
-- highlight {"LspDiagnosticsDefaultInformation", fg = "LightBlue"}
highlight {"LspDiagnosticsDefaultWarning", fg = "Orange"}
-- highlight {"LspDiagnosticsDefaultError", fg = "Red"}
highlight {"FloatBorder", fg = "gray"}

local lsp_signs = {
  LspDiagnosticsSignHint = {text = u "f0eb", texthl = "LspDiagnosticsSignHint"},
  LspDiagnosticsSignInformation = {
    text = u "f129",
    texthl = "LspDiagnosticsSignInformation",
  },
  LspDiagnosticsSignWarning = {
    text = u "f071",
    texthl = "LspDiagnosticsSignWarning",
  },
  LspDiagnosticsSignError = {
    text = u "f46e",
    texthl = "LspDiagnosticsSignError",
  },
}

for hl_group, config in pairs(lsp_signs) do
  vim.fn.sign_define(hl_group, config)
end

lsp_config.tsserver.setup {
  cmd = {
    "typescript-language-server",
    "--stdio",
    "tsserver-log-verbosity",
    "off",
  },
  root_dir = root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    vim.fn.getcwd()
  ),
}

-- lsp_config.flow.setup {
--   cmd = {'flow', 'lsp'},
--   filetypes = {'javascript', 'javascriptreact'},
--   root_dir = root_pattern('.flowconfig'),
-- }

-- lsp_config.pyls.setup {
--   cmd = {'pyls'},
--   filetypes = {'python'},
--   settings = {
--     pyls = {
--       plugins = {
--         jedi_completion = {enabled = true},
--         jedi_hover = {enabled = true},
--         jedi_references = {enabled = true},
--         jedi_signature_help = {enabled = true},
--         jedi_symbols = {enabled = true, all_scopes = true},
--         yapf = {enabled = false},
--         pylint = {enabled = false},
--         pycodestyle = {enabled = false},
--         pydocstyle = {enabled = false},
--         mccabe = {enabled = false},
--         preload = {enabled = false},
--         rope_completion = {enabled = false},
--       },
--     },
--   },
-- }

lsp_config.pyright.setup {}

lsp_config.sumneko_lua.setup {
  cmd = {
    "lua-language-server",
    "-E", "/usr/share/lua-language-server/main.lua",
    "--logpath",
    vim.lsp.get_log_path():match("(.*[/\\])"),
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = {"vim", "dump", "love"},
      },
      workspace = {
        library = {
          [expand("$VIMRUNTIME/lua")] = true,
          [expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
}

-- require('lspconfig/configs').lua_emmy = {
--     default_config = {
--         cmd = {
--             'java', '-cp',
--             '/usr/lib/lua-emmy-language-server/EmmyLua-LS-all.jar',
--             'com.tang.vscode.MainKt',
--         },
--         filetypes = {'lua'},
--         root_dir = root_pattern(vim.fn.getcwd()),
--         settings = {},
--     },
-- }

-- lsp_config.lua_emmy.setup {}

lsp_config.rust_analyzer.setup {}

lsp_config.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = root_pattern("go.mod", ".git", vim.fn.getcwd()),
}

lsp_config.hls.setup {
  settings = {haskell = {formattingProvider = "brittany"}},
  root_dir = root_pattern(
    "*.cabal",
    "stack.yaml",
    "cabal.project",
    "package.yaml",
    "hie.yaml",
    vim.fn.getcwd()
  ),
}

do
  local clangdcmd = {"clangd", "--background-index"}
  if vim.fn.empty(vim.fn.glob("compile_commands.json")) == 1 then
    vim.tbl_extend("force", clangdcmd, {"--compile-commands-dir", "build"})
  end

  lsp_config.clangd.setup {
    cmd = clangdcmd,
    filetypes = {"c", "cpp", "objc", "objcpp"},
    root_dir = root_pattern(
      "CMakeLists.txt",
      "compile_flags.txt",
      ".git",
      vim.fn.getcwd()
    ),
  }
end

lsp_config.svelte.setup {}

do
  local schemas = {
    {
      fileMatch = {"tsconfig.json", "tsconfig.*.json"},
      url = "http://json.schemastore.org/tsconfig",
    },
  }
  lsp_config.jsonls.setup {
    cmd = {"vscode-json-languageserver", "--stdio"},
    filetypes = {"json", "jsonc"},
    -- init_options = {provideFormatter = true},
    root_dir = root_pattern(".git", vim.fn.getcwd()),
    settings = {json = {schemas = schemas}},
  }
end

lsp_config.html.setup {}

lsp_config.yamlls.setup {}

lsp_config.bashls.setup {filetypes = {'bash', 'sh', 'zsh'}}

lsp_config.solargraph.setup {}

if vim.fn.has("win64") == 1 then
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
  if vim.fn.has("win64") == 1 then
    cmd = {
      expand(
        "~/Projects/kotlin-language-server/server/build/install" ..
        "/server/bin/kotlin-language-server.bat"
      ),
    }
  end
  if vim.fn.has("unix") == 1 then
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
  local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true,
  }
  local languages = {
    javascript = {eslint},
    javascriptreact = {eslint},
    typescript = {eslint},
    typescriptreact = {eslint},
  }
  lsp_config.efm.setup {
    cmd = {"efm-langserver"},
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.goto_definition = false
    end,
    setttings = {
      languages = languages,
      log_level = 1,
      log_file = vim.fn.expand("~/.config/efm-langserver/efm.log"),
    },
    root_dir = root_pattern(".eslintrc.yml"),
    filetypes = vim.tbl_keys(languages),
  }
end

local win_border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
local function setup_hover()
  local method = 'textDocument/hover'
  lsp.handlers[method] = lsp.with(lsp.handlers[method], {border = win_border})
end

local USE_DIAGNOSTIC_QUICKFIX = false

local function setup_diagnostics()
  local method = 'textDocument/publishDiagnostics'
  local on_publish_cfg = {
    underline = true,
    virtual_text = true,
    update_in_insert = false,
  }
  local diagnostics_handler = lsp.with(
    lsp.diagnostic.on_publish_diagnostics, on_publish_cfg
  )
  lsp.handlers[method] = diagnostics_handler

  if USE_DIAGNOSTIC_QUICKFIX then
    lsp.handlers[method] = function(...)
      diagnostics_handler(...)
      local all_diagnostics = vim.lsp.diagnostic.get_all()
      local qflist = {}
      for bufnr, diagnostic in pairs(all_diagnostics) do
        for _, diag in ipairs(diagnostic) do
          local item = {
            bufnr = bufnr,
            lnum = diag.range.start.line + 1,
            col = diag.range.start.character + 1,
            text = diag.message,
          }
          if diag.severity == 1 then
            item.type = 'E'
          elseif diag.severity == 2 then
            item.type = 'W'
          end
          table.insert(qflist, item)
        end
      end
      vim.fn.setqflist(qflist)
    end
  end
end

local function setup_formatting()
  local method = 'textDocument/formatting'
  local defaut_handler = lsp.handlers[method]
  lsp.handlers[method] = function(...)
    -- local err, method, result, client_id, bufnr, config = ...
    -- dump {
    --   err = err,
    --   method = method,
    --   result = result,
    --   client_id = client_id,
    --   bufnr = bufnr,
    --   config = config,
    -- }
    local err = ...
    if err == nil then
      defaut_handler(...)
    else
      vim.cmd('Neoformat')
    end
  end
end

setup_diagnostics()
setup_formatting()
setup_hover()
