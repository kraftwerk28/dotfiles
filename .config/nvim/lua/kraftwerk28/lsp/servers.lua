local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern
local cmp_lsp = require("cmp_nvim_lsp")

local function make_capabilities()
  return cmp_lsp.default_capabilities()
end

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

vim.lsp.config("*", {
  capabilities = make_capabilities(),
  -- on_attach = function(client, bufnr)
  --   vim.print("config for *")
  -- end,
})

vim.lsp.enable "awk_ls"

vim.lsp.config.denols = {
  autostart = false,
  initializationOptions = {
    enable = true,
    lint = true,
    unstable = false,
  },
}
vim.lsp.enable "denols"

vim.lsp.enable "gopls"

vim.lsp.enable "graphql"

vim.lsp.config.hls = {
  settings = {
    haskell = {
      -- formattingProvider = "brittany",
      formattingProvider = "ormolu",
    },
  },
}
vim.lsp.enable "hls"

vim.lsp.config.pyright = {
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
vim.lsp.enable "pyright"

vim.lsp.enable "rust_analyzer"

do
  local ts_plugins = {}
  local vue_plugin_dir = vim.env.XDG_DATA_HOME
    .. "/fnm/aliases/default/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
  if vim.fn.isdirectory(vue_plugin_dir) ~= 0 then
    table.insert(ts_plugins, {
      name = "@vue/typescript-plugin",
      -- NOTE: update the path every time global node version is changed
      location = vue_plugin_dir,
      languages = { "javascript", "typescript", "vue" },
    })
  end

  vim.lsp.config.ts_ls = {
    init_options = {
      hostInfo = "neovim",
      preferences = {
        importModuleSpecifierPreference = "relative",
      },
      plugins = ts_plugins,
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

    -- NOTE: this callback is removed in builtin lsp engine :(
    -- See https://github.com/neovim/neovim/issues/32287
    _on_new_config = function(new_config)
      local location = _G.vue_ts_plugin_location
      if location == nil then
        local npm_cmd = vim
          .system { "npm", "list", "--global", "--parseable", "@vue/typescript-plugin" }
          :wait()
        if npm_cmd.code == 0 then
          location = vim.fn.split(npm_cmd.stdout)[1]
          _G.vue_ts_plugin_location = location
        end
      end
      if location ~= nil then
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
end
vim.lsp.enable "ts_ls"

vim.lsp.enable "vue_ls"

vim.lsp.config.typescript_go = {
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

vim.lsp.config.svelte = {
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
vim.lsp.enable "svelte"

vim.lsp.config.jsonls = {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = {
        enable = true,
      },
    },
  },
}
vim.lsp.enable "jsonls"

vim.lsp.config.yamlls = {
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
}
vim.lsp.enable "yamlls"

vim.lsp.enable "cssls"

vim.lsp.enable "metals"

vim.lsp.enable "solargraph"

vim.lsp.enable "erlangls"

vim.lsp.config.rescriptls = {
  cmd = { "rescript-ls", "--stdio" },
}
vim.lsp.enable "rescriptls"

vim.lsp.enable "elmls"

vim.lsp.config.tailwindcss = {
  filetypes = { "vue", "svelte" },
}
vim.lsp.enable "tailwindcss"

vim.lsp.config.lua_ls = {
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
vim.lsp.enable "lua_ls"

vim.lsp.enable "serve_d"

if vim.fn.has "win64" == 1 then
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
