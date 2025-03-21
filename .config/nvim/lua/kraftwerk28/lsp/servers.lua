local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern
local cmp_lsp = require("cmp_nvim_lsp")

local function make_capabilities()
  return cmp_lsp.default_capabilities()
end

local configs = require "lspconfig.configs"

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
  lspconfig.arduino_language_server.setup {
    cmd = cmd,
    -- NOTE: default capabilities are not empty, do not overwrite them
    -- capabilities = make_capabilities(),
  }
end

lspconfig.awk_ls.setup {
  capabilities = make_capabilities(),
}

lspconfig.denols.setup {
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
  capabilities = make_capabilities(),
}

lspconfig.gopls.setup {
  capabilities = make_capabilities(),
}

lspconfig.graphql.setup {
  capabilities = make_capabilities(),
}

lspconfig.hls.setup {
  settings = {
    haskell = {
      -- formattingProvider = "brittany",
      formattingProvider = "ormolu",
    },
  },
  capabilities = make_capabilities(),
}

lspconfig.pyright.setup {
  capabilities = make_capabilities(),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

lspconfig.rust_analyzer.setup {
  capabilities = make_capabilities(),
}

lspconfig.ts_ls.setup {
  capabilities = make_capabilities(),
  init_options = {
    hostInfo = "neovim",
    preferences = {
      importModuleSpecifierPreference = "relative",
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  on_attach = function(client, bufnr)
    require("twoslash-queries").attach(client, bufnr)
  end,
  on_new_config = function(new_config)
    local npm_cmd = vim
      .system { "npm", "list", "--global", "--parseable", "@vue/typescript-plugin" }
      :wait()
    local location = vim.fn.split(npm_cmd.stdout)[1]
    if npm_cmd.code == 0 and location then
      new_config.init_options.plugins = {
        {
          name = "@vue/typescript-plugin",
          location = location,
          languages = { "javascript", "typescript", "vue" },
        },
      }
    end
  end,
}

lspconfig.volar.setup {}

configs.typescript_go = {
  default_config = {
    cmd = { "tsgo", "lsp", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
    },
    root_dir = root_pattern(
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git"
    ),
  },
}

-- lspconfig.typescript_go.setup {
--   capabilities = make_capabilities(),
--   on_attach = function(client, bufnr)
--     require("twoslash-queries").attach(client, bufnr)
--   end,
-- }

-- lspconfig.flow.setup {
--   cmd = {'flow', 'lsp'},
--   filetypes = {'javascript', 'javascriptreact'},
--   root_dir = root_pattern('.flowconfig'),
-- }

do
  local query_drivers = {
    host = "/usr/bin/{gcc,g++,c++,cpp}",
    stm32 = "/usr/bin/arm-none-eabi-{gcc,g++,c++,cpp}",
    esp32 = "/home/kraftwerk28/.espressif/tools/xtensa-esp32*-elf/*/*/bin/xtensa-esp32*-elf-{gcc,g++,c++,cpp}",
  }

  lspconfig.clangd.setup {
    cmd = {
      "clangd",
      "--background-index",
      "--header-insertion=never",
      "-j",
      "8",
      "--pch-storage=memory",
      -- "--query-driver=" .. table.concat(vim.tbl_values(query_drivers), ","),
    },
    capabilities = make_capabilities(),
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
  }
end

lspconfig.svelte.setup {
  capabilities = make_capabilities(),
  settings = {
    svelte = {
      plugin = {
        typescript = {
          semanticTokens = { enable = false },
        },
      },
    },
  },
}

lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = {
        enable = true,
      },
    },
  },
  capabilities = make_capabilities(),
}

lspconfig.yamlls.setup {
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
  capabilities = make_capabilities(),
}

lspconfig.cssls.setup {
  capabilities = make_capabilities(),
}

lspconfig.metals.setup {}

lspconfig.solargraph.setup {
  capabilities = make_capabilities(),
}

lspconfig.erlangls.setup {
  capabilities = make_capabilities(),
}

lspconfig.rescriptls.setup {
  cmd = { "rescript-ls", "--stdio" },
  capabilities = make_capabilities(),
}

lspconfig.elmls.setup {}

lspconfig.tailwindcss.setup {
  filetypes = { "vue", "svelte" },
}

lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        vim.loop.fs_stat(path .. "/.luarc.json")
        or vim.loop.fs_stat(path .. "/.luarc.jsonc")
      then
        return
      end
    end
    local settings = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    }
    client.config.settings.Lua =
      vim.tbl_deep_extend("force", client.config.settings.Lua, settings)
  end,
  settings = {
    Lua = {},
  },
}

lspconfig.serve_d.setup {}

if vim.fn.has("win64") == 1 then
  local jdt_base = vim.fn.expand(
    "~/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
  )
  local java_home = vim.fn.expand("C:/Program Files/Java/jdk-11.0.11")

  lspconfig.jdtls.setup({
    cmd = {
      vim.fn.expand(java_home .. "/bin/java.exe"),
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1G",
      "-jar",
      vim.fn.expand(
        jdt_base
          .. "/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar"
      ),
      "-configuration",
      vim.fn.expand(jdt_base .. "/config_win"),
      "-data",
      vim.fn.expand("~/Projects/jdt-ls-data"),
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
      vim.fn.expand(
        "~/Projects/groovy-language-server"
          .. "/build/libs/groovy-language-server-all.jar"
      ),
    },
  })
end
