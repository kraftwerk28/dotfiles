#!/usr/bin/env luajit
local i3 = require"i3ipc"

local prev_focused
-- { con_id => { input_identifier => layout_index } }
local windows = {}

local function on_focus(ipc, event)
  local con_id = event.container.id
  local inputs = ipc:get_keyboard_inputs()
  local input_layouting = {}
  for _, input in ipairs(inputs) do
    input_layouting[input.identifier] = input.xkb_active_layout_index
  end
  if prev_focused ~= nil and prev_focused ~= con_id then
    windows[prev_focused] = input_layouting
  end
  local cached_layouts = windows[con_id]
  local commands = {}
  if cached_layouts ~= nil then
    for input_id, layout_index in pairs(cached_layouts) do
      if layout_index ~= input_layouting[input_id] then
        table.insert(
          commands,
          ('input "%s" xkb_switch_layout %d'):format(input_id, layout_index)
        )
      end
    end
  else
    for _, input in ipairs(inputs) do
      if input.xkb_active_layout_index ~= 0 then
        table.insert(
          commands,
          ('input "%s" xkb_switch_layout %d'):format(input.identifier, 0)
        )
      end
    end
  end
  if #commands > 0 then
    ipc:command(table.concat(commands, ", "))
  end
  prev_focused = con_id
end

-- TODO: utilize this function
local function focus_back_and_forth(ipc)
  ipc:command(("[con_id=%d] focus"):format(prev_focused))
end

local function on_close(_, event)
  windows[event.container.id] = nil
end

local function on_workspace_init(ipc, _)
  for _, input in ipairs(ipc:get_keyboard_inputs()) do
    ipc:command(
      ('input "%s" xkb_switch_layout %d'):format(input.identifier, 0)
    )
  end
end

i3.main(function(conn)
  function conn:get_keyboard_inputs()
    local inputs, r = self:get_inputs(), {}
    for _, input in ipairs(inputs) do
      if input.type == "keyboard" and input.xkb_active_layout_index ~= nil then
        table.insert(r, input)
      end
    end
    return r
  end

  conn:on("window::focus", on_focus)
  conn:on("window::close", on_close)
  conn:on("workspace::init", on_workspace_init)
end)
