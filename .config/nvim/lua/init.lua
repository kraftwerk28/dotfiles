local M = {}

local function debounce(func, timeout)
   local timer_id = nil
   return function(...)
      if timer_id ~= nil then
         vim.fn.timer_stop(timer_id)
      end
      local args = {...}

      timer_id = vim.fn.timer_start(timeout, function()
         func(args)
         timer_id = nil
      end)
   end
end

local function throttle(func, timeout)
   local timer_id = nil
   return function(...)
      if timer_id == nil then
         func{...}
         timer_id = vim.fn.timer_start(timeout, function()
            timer_id = nil
         end)
      end
   end
end

local function setup_treesitter()
   local ts = require'nvim-treesitter.configs'
   ts.setup {
      ensure_installed = 'maintained',
      highlight = {
         enable = true,
         disable = {'dart', 'ocaml', 'java', 'clojure'},
      },
      -- indent = { enable = true },
   }
end

local function setup_lsp()
   local lsp = require'lspconfig'
   -- on_attach is called in init.vim

   local ts_cfg = {
      cmd = {'typescript-language-server', '--stdio'},
      filetypes = {
         'javascript',
         'javascriptreact',
         'typescript',
         'typescriptreact',
      },
      root_dir = lsp.util.root_pattern(
         'package.json',
         'tsconfig.json',
         '.git'
      ),
   }

   local pyls_cfg = {
      cmd = {'pyls'},
      filetypes = {'python'},

      jedi_completion = {enabled = true},
      jedi_hover = {enabled = true},
      jedi_references = {enabled = true},
      jedi_signature_help = {enabled = true},
      jedi_symbols = {enabled = true, all_scopes = true},

      mccabe = {enabled = true, threshold = 15},
      preload = {enabled = true},

      pycodestyle = {enabled = true},
      pydocstyle = {
         enabled = false,
         match = '(?!test_).*\\.py',
         matchDir = '[^\\.].*',
      },

      rope_completion = {enabled = true},
      yapf = {enabled = true},
   }

   local lua_cfg = {cmd = {'lua-language-server'}}

   lsp.tsserver.setup(ts_cfg)
   lsp.pyls.setup(pyls_cfg)
   lsp.rust_analyzer.setup{}
   lsp.gopls.setup{}
   lsp.hls.setup{}
   lsp.sumneko_lua.setup(lua_cfg)
   lsp.clangd.setup{}

   local on_publish_cfg = {
      underline = true,
      virtual_text = false,
      update_in_insert = false,
   }

   vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      on_publish_cfg
   )
end

local function setup_telescope()
   local actions = require('telescope.actions')
   local telescope = require('telescope')
   local mappings = {
      i = {
         ['<C-P>'] = false,
         ['<C-N>'] = false,
         ['<C-J>'] = actions.move_selection_next,
         ['<C-K>'] = actions.move_selection_previous,
         ['<Esc>'] = actions.close,
      },
   },
   telescope.setup{defaults = {mappings = mappings}}
end

M.show_LSP_diagnostics = debounce(
   vim.lsp.diagnostic.show_line_diagnostics,
   300
)

function M.setup()
   setup_treesitter()
   setup_lsp()
end

return M
