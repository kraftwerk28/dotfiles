local utils = require("config.utils")
local fn, api = vim.fn, vim.api

-- Below are just a messy experiments that don't make any sense
utils.nnoremap("<Leader>ar", function()
  local _, line_num, col_num, _, _ = unpack(fn.getcurpos())
  line_num = line_num - 1
  col_num = col_num - 1

  -- local bufnum, start_row, start_col, _ = unpack(fn.getpos("'<"))
  -- local _, end_row, end_col, _ = unpack(fn.getpos("'>"))
  -- start_row = start_row - 1
  -- start_col = start_col - 1
  -- end_row = end_row - 1

  local parser = vim.treesitter.get_parser()
  local root_node = parser:parse()[1]:root()

  local arguments_node =
    root_node:named_descendant_for_range(line_num, col_num, line_num, col_num)
  while true do
    local type = arguments_node:type()
    if arguments_node == root_node then
      print("Not inside arguments")
      return
    elseif type ~= "arguments" then
      arguments_node = arguments_node:parent()
    else
      break
    end
  end

  local child_count = arguments_node:named_child_count()
  for i = 0, child_count - 1 do
    local child = arguments_node:named_child(i)
    local line, col, e_line, e_col = child:range()
    print(("%s; [%d %d, %d, %d]"):format(child:type(), line, col, e_line, e_col))
    fn.cursor(line+1, col+1)
    break
  end
  -- for child in arguments_node:iter_children() do
  --   if child:named() then
  --     print("Child type: "..child:type())
  --     print("Child sexpr: "..child:sexpr())
  --     print(child:range())
  --   end
  -- end
end)

-- List of all highlight groups
local highlight_groups = {}
local forbidden_patterns = {
  "^DevIcon", "Debug",
}

do
  local highlight_names = vim.fn.getcompletion("", "highlight")
  for _, name in ipairs(highlight_names) do
    for _, pat in ipairs(forbidden_patterns) do
      if name:match(pat) then
        goto continue
      end
    end
    local hl = api.nvim_get_hl_by_name(name, true)
    hl.name = name
    table.insert(highlight_groups, hl)
    ::continue::
  end
end

local function color_distance(a, b)
  return
    math.abs(bit.rshift(a, 16) - bit.rshift(b, 16)) +
    math.abs(bit.band(bit.rshift(a, 8), 0xff) - bit.band(bit.rshift(b, 8), 0xff)) +
    math.abs(bit.band(a, 0xff) - bit.band(b, 0xff))
end

function _G.get_closest_highlight(hl)
  local closest = 0xffffffff
  local closest_hl_group = highlight_groups[1]
  for _, group in ipairs(highlight_groups) do
    local d = 0
    for k, v in pairs(hl) do
      if group[k] == nil then
        d = d + 0xff
      else
        d = d + color_distance(v, group[k])
      end
    end
    if d < closest then
      closest = d
      closest_hl_group = group
    end
  end
  vim.cmd("hi "..closest_hl_group.name)
  return closest_hl_group
end

-- local tm = vim.loop.new_timer()
-- local count = 0
-- tm:start(1000, 1000, vim.schedule_wrap(function()
--   count = count + 1
--   dump{count, fn.getpos("'<"), fn.getpos("'>")}
-- end))

do
  local api = {}
  local api_mt = {}
  function api_mt:__index(k)
    local t = {unpack(self)}
    table.insert(t, k)
    return setmetatable(t, api_mt)
  end
  function api_mt:__call(...)
    return vim.api["nvim_"..table.concat(self, "_")](...)
  end
  setmetatable(api, api_mt)
  _G.api = api
end
