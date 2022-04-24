#!/usr/bin/env luajit
local i3 = require("i3ipc")

local current_focused, previous_focused
-- { con_id => { input_identifier => layout_index } }
local windows = {}

local ipc = i3.Connection:new()

function ipc:get_keyboard_inputs()
  local inputs, r = self:get_inputs(), {}
  for _, input in ipairs(inputs) do
    if input.type == "keyboard" and input.xkb_active_layout_index ~= nil then
      table.insert(r, input)
    end
  end
  return r
end

ipc:main(function()
  ipc.cmd:on("tab", function(arg)
    local tabbed_node = ipc:get_tree():walk_focus(function(n)
      return n.layout == "tabbed"
    end)
    if not tabbed_node then return end
    local focused_index
    for index, node in ipairs(tabbed_node.nodes) do
      if node.id == tabbed_node.focus[1] then
        focused_index = index
      end
    end
    if arg == "prev" then
      focused_index =
        (focused_index - 2 + #tabbed_node.nodes) % #tabbed_node.nodes + 1
    else
      focused_index = focused_index % #tabbed_node.nodes + 1
    end
    local to_be_focused =
      i3.wrap_node(tabbed_node.nodes[focused_index]):walk_focus()
    ipc:command(("[con_id=%d] focus"):format(to_be_focused.id))
  end)

  ipc.cmd:on("focus_prev", function()
    if not previous_focused then return end
    ipc:command(("[con_id=%d] focus"):format(previous_focused))
  end)

  ipc.cmd:on("next_float", function()
    ipc:once("window::new", function(event)
      ipc:command(("[con_id=%s] floating enable"):format(event.container.id))
    end)
  end)

  ipc:on("window::focus", function (event)
    previous_focused = current_focused
    local con_id = event.container.id
    local inputs = ipc:get_keyboard_inputs()
    local input_layouting = {}
    for _, input in ipairs(inputs) do
      input_layouting[input.identifier] = input.xkb_active_layout_index
    end
    if previous_focused ~= nil and previous_focused ~= con_id then
      windows[previous_focused] = input_layouting
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
    current_focused = con_id
  end)

  ipc:on("window::close", function(event)
    windows[event.container.id] = nil
  end)

  -- When using nested sway, it's convenient to exit special mode which
  -- disables all bindings in "outer" sway
  ipc:on("window", function(event)
    if event.container.app_id == "wlroots" then
      if event.change == "new" then
        ipc:command("mode nested_sway")
      elseif event.change == "close" then
        ipc:command("mode default")
      end
    end
  end)

  ipc:on("workspace::init", function()
    for _, input in ipairs(ipc:get_keyboard_inputs()) do
      ipc:command(
        ('input "%s" xkb_switch_layout %d'):format(input.identifier, 0)
      )
    end
  end)

end)
