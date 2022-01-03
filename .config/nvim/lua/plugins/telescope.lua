-- local pickers = require('telescope.pickers')
-- local finders = require('telescope.finders')
-- local sorters = require('telescope.sorters')
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

local telescope = require("telescope")
local actions = require("telescope.actions")
local u = require("config.utils").u

telescope.setup {
  defaults = {
    sorting_strategy = "ascending",
    prompt_prefix = u"f002" .. " ",
    layout_strategy = "horizontal",
    layout_config = {prompt_position = "top"},
    selection_caret = u"f054" .. ' ',
    color_devicons = true,
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
      hidden = true,
    },
  },
}
