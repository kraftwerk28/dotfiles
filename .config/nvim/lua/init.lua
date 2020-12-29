local M = {}

local function get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

local function debounce(func, timeout)
    local timer_id = nil
    return function(...)
        if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
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
            func {...}
            timer_id = vim.fn.timer_start(timeout, function()
                timer_id = nil
            end)
        end
    end
end

local function lsp_diagnostics_helper()
    local debounced = debounce(vim.lsp.diagnostic.show_line_diagnostics, 300)
    local cursorpos = get_cursor_pos()
    return function()
        local new_cursor = get_cursor_pos()
        if (new_cursor[1] ~= 1 and new_cursor[2] ~= 1) and
            (new_cursor[1] ~= cursorpos[1] or new_cursor[2] ~= cursorpos[2]) then
            cursorpos = new_cursor
            debounced()
        end
    end
end

M.show_lsp_diagnostics = lsp_diagnostics_helper()

local function setup_treesitter()
    local ts = require 'nvim-treesitter.configs'
    ts.setup {
        ensure_installed = 'maintained',
        highlight = {
            enable = true,
            disable = {'dart', 'ocaml', 'java', 'clojure'}
        }
        -- indent = { enable = true },
    }
end

function M.get_nwarnings()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return 0
    else
        return vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Warning')
    end
end

function M.get_nerrors()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return
    else
        return vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), 'Error')
    end
end

local function setup_lsp()
    local lsp = require 'lspconfig'
    -- on_attach is called in init.vim

    local ts_cfg = {
        cmd = {'typescript-language-server', '--stdio'},
        filetypes = {
            'javascript', 'javascriptreact', 'typescript', 'typescriptreact'
        },
        root_dir = lsp.util
            .root_pattern('package.json', 'tsconfig.json', '.git')
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
            matchDir = '[^\\.].*'
        },

        rope_completion = {enabled = true},
        yapf = {enabled = true}
    }

    local lua_cfg = {cmd = {'lua-language-server'}}

    lsp.tsserver.setup(ts_cfg)
    lsp.pyls.setup(pyls_cfg)
    lsp.rust_analyzer.setup {}
    lsp.gopls.setup {}
    lsp.hls.setup {}
    lsp.sumneko_lua.setup(lua_cfg)
    lsp.clangd.setup {}

    local on_publish_cfg = {
        underline = true,
        virtual_text = true,
        update_in_insert = false
    }

    local on_publish_handler = vim.lsp.with(
                                   vim.lsp.diagnostic.on_publish_diagnostics,
                                   on_publish_cfg)

    -- vim.lsp.handlers['textDocument/codeAction'] =
    --     function(err, method, result, client_id, bufnr, config)
    --         print('textDocument/codeAction', err, method, result, client_id,
    --               bufnr, config)
    --     end

    vim.lsp.handlers['textDocument/publishDiagnostics'] =
        function(...)
            vim.api.nvim_command('doautocmd User LSPOnDiagnostics')
            on_publish_handler(...)
        end
end

function M.setup()
    setup_treesitter()
    setup_lsp()
end

return M
