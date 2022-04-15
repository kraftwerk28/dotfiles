local telescope = require("telescope")
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function lsp_client_to_entry(entry)
  return { value = entry, display = entry.name, ordinal = entry.name }
end

-- _G.base16 = function(opts)
--   local results = {}
--   for i = 1, 50 do
--     table.insert(results, 'Result #' .. i)
--   end
--   pickers:new(opts, {
--     prompt_title = "base16 themes",
--     finder = finders.new_table {
--       results = results,
--     },
--     sorter = sorters.fuzzy_with_index_bias(),
--   }):find()
-- end

telescope.setup {
  defaults = {
    sorting_strategy = "ascending",
    prompt_prefix = " ",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
    },
    selection_caret = " ",
    -- color_devicons = true,
    scroll_strategy = "cycle",
    mappings = {
      i = {
        ["<C-K>"] = actions.move_selection_previous,
        ["<C-J>"] = actions.move_selection_next,
        ["<Esc>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      previewer = false,
      theme = "dropdown",
      hidden = true, -- show hidden files
    },
  },
  extensions = {
    tele_tabby = {
      use_highlighter = true,
    }
  }
}

local lsp_pickers = {
  lsp_restart = function(opts)
    pickers.new(opts, {
      prompt_title = "Restart LSP server",
      finder = finders.new_table {
        results = vim.lsp.buf_get_clients(),
        entry_maker = lsp_client_to_entry,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local configs = require("lspconfig.configs")
          local entry = action_state.get_selected_entry()
          local client = entry.value
          if configs[client.name] == nil then
            print(client.name .. " doesn't support restarting.")
            return
          end
          client.stop()
          vim.defer_fn(function() configs[client.name].launch() end, 500)
        end)
        return true
      end,
    }):find()
  end,
  lsp_stop = function(opts)
    pickers.new(opts, {
      prompt_title = "Stop LSP server",
      finder = finders.new_table({
        results = vim.tbl_filter(
          function(c) return not c.is_stopped() end,
          vim.lsp.buf_get_clients()
        ),
        entry_maker = lsp_client_to_entry,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          entry.value.stop()
        end)
        return true
      end,
    }):find()
  end,
  lsp_start = function(opts)
    pickers.new(opts, {
      prompt_title = "Start LSP server",
      finder = finders.new_table({
        results = require("lspconfig").available_servers(),
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.close(prompt_bufnr)
        local server_name = action_state.get_selected_entry()
        print(vim.inspect(server_name))
      end,
    }):find()
  end,
}

-- TODO: put these pickers to the `:Telescope` command
for k, v in pairs(lsp_pickers) do
  _G[k] = v
end
