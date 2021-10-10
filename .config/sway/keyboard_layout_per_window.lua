#!/usr/bin/env luajit
local i3 = require"i3ipc"

local prev_focused
-- { con_id => { input_identifier => layout_index } }
local windows = {}

local function on_focus(conn, event)
  if event.change ~= "focus" then
    return
  end
  local con_id = event.container.id
  local inputs = conn:get_keyboard_inputs(conn)
  local input_layouting = {}
  for _, input in ipairs(inputs) do
    input_layouting[input.identifier] = input.xkb_active_layout_index
  end
  if prev_focused ~= nil and prev_focused ~= con_id then
    windows[prev_focused] = input_layouting
  end
  local cached_layouts = windows[con_id]
  if cached_layouts ~= nil then
    for input_id, layout_index in pairs(cached_layouts) do
      if layout_index ~= input_layouting[input_id] then
        conn:command(
          ([[input "%s" xkb_switch_layout %d]]):format(input_id, layout_index)
        )
      end
    end
  else
    for _, input in ipairs(inputs) do
      if input.xkb_active_layout_index ~= 0 then
        conn:command(
          ([[input "%s" xkb_switch_layout %d]]):format(input.identifier, 0)
        )
      end
    end
  end
  prev_focused = con_id
end

local function on_close(conn, event)
  if event.change ~= "close" then
    return
  end
  windows[event.container.id] = nil
end

local function on_workspace_init(conn, event)
  if event.change ~= "init" then
    return
  end
  for _, input in ipairs(conn:get_keyboard_inputs(conn)) do
    conn:command(([[input "%s" xkb_switch_layout %d]]):format(input.identifier, 0))
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

  conn:on(i3.EVENT.WINDOW, on_focus)
  conn:on(i3.EVENT.WINDOW, on_close)
  conn:on(i3.EVENT.WORKSPACE, on_workspace_init)
end)
