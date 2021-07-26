#!/usr/bin/env python
from i3ipc import Connection, Event

prev_focused = -1
windows = {}


def on_window_focus(ipc, event):
    global windows, prev_focused
    # Save current layout
    layouts = {}
    for input in ipc.get_inputs():
        layouts[input.identifier] = input.xkb_active_layout_index
    windows[prev_focused] = layouts
    # Restore layout of the newly focused window
    for (input_id, layout_index) in windows.get(event.container.id, {}).items():
        if layout_index != layouts[input_id]:
            cmd = f"input \"{input_id}\" xkb_switch_layout {layout_index}"
            ipc.command(cmd)
    prev_focused = event.container.id


def on_window_close(ipc, event):
    global windows
    if event.container.id in windows:
        del windows[event.container.id]


def on_window(ipc, event):
    if event.change == "focus":
        on_window_focus(ipc, event)
    elif event.change == "close":
        on_window_close(ipc, event)


if __name__ == "__main__":
    ipc = Connection()
    ipc.on(Event.WINDOW, on_window)
    ipc.main()
