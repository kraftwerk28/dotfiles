#!/usr/bin/env python
from i3ipc import Connection, Event, events

prev_focused = -1
windows = {}
DEFAULT_LAYOUT_INDEX = 0

def dump_event(event):
    import os
    os.system(f"notify-send {event.change}")


def focus_handler(ipc: Connection, event: events.WindowEvent):
    dump_event(event)
    global windows, prev_focused

    # Save current layout
    inputs = ipc.get_inputs()
    input_layout_data = {}
    for input in inputs:
        if (index := input.xkb_active_layout_index) is not None:
            input_layout_data[input.identifier] = index
    if prev_focused != -1:
        windows[prev_focused] = input_layout_data

    container_id = event.container.id
    # Restore layout of the newly focused window
    if (cur_layout_data := windows.get(container_id, None)) is not None:
        for input_id, layout_index in cur_layout_data.items():
            if layout_index != input_layout_data.get(input_id, None):
                ipc.command(
                    f"input \"{input_id}\" xkb_switch_layout "
                    f"{layout_index}"
                )
    else:
        for input in inputs:
            if input.xkb_active_layout_index != DEFAULT_LAYOUT_INDEX:
                ipc.command(
                    f"input \"{input.identifier}\" xkb_switch_layout "
                    f"{DEFAULT_LAYOUT_INDEX}"
                )

    prev_focused = container_id


def close_handler(ipc, event):
    windows.pop(event.container.id, None)


def workspace_init_handler(ipc: Connection, event: events.WorkspaceEvent):
    dump_event(event)
    for input in ipc.get_inputs():
        ipc.command(
            f"input \"{input.identifier}\" xkb_switch_layout "
            f"{DEFAULT_LAYOUT_INDEX}"
        )


if __name__ == "__main__":
    ipc = Connection()
    focused = ipc.get_tree().find_focused()
    if focused is not None:
        prev_focused = focused.id
    ipc.on(Event.WINDOW_FOCUS, focus_handler)
    ipc.on(Event.WINDOW_CLOSE, close_handler)
    # ipc.on(Event.WORKSPACE_INIT, workspace_init_handler)
    ipc.main()
