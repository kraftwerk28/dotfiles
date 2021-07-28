#!/usr/bin/env python
from i3ipc import Connection, Event

prev_focused = -1
windows = {}


def on_window_focus(ipc, event):
    global windows, prev_focused

    # Save current layout
    inputs = ipc.get_inputs()
    input_layout_data = {}
    for input in inputs:
        index = input.xkb_active_layout_index
        if index is not None:
            input_layout_data[input.identifier] = index
    if prev_focused != -1:
        windows[prev_focused] = input_layout_data

    # Restore layout of the newly focused window
    if (container_id := event.container.id) in windows:
        for input_id, layout_index in windows[container_id].items():
            if layout_index != input_layout_data[input_id]:
                cmd = f"input \"{input_id}\" xkb_switch_layout {layout_index}"
                ipc.command(cmd)
    else:
        for input in inputs:
            cmd = f"input \"{input.identifier}\" xkb_switch_layout 0"
            ipc.command(cmd)

    prev_focused = container_id


def on_window_close(ipc, event):
    global windows
    if (container_id := event.container.id) in windows:
        del windows[container_id]


def on_window(ipc, event):
    if event.change == "focus":
        on_window_focus(ipc, event)
    elif event.change == "close":
        on_window_close(ipc, event)

def on_new_window(ipc, event):
    pass


if __name__ == "__main__":
    ipc = Connection()
    focused = ipc.get_tree().find_focused()
    if focused is not None:
        prev_focused = focused.id
    ipc.on(Event.WINDOW, on_window)
    # ipc.on(Event.WINDOW_NEW, on_new_window)
    ipc.main()
