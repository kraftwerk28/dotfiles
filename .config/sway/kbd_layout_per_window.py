#!/usr/bin/env python
from i3ipc import Connection, Event

prev_focused = -1
windows = {}


def focus_handler(ipc, event):
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


def close_handler(ipc, event):
    global windows
    if (container_id := event.container.id) in windows:
        del windows[container_id]


# FLOATING_TRESHOLD = 360000


# def autofloating_handler(ipc, event):
#     from pprint import pprint
#     container = event.container
#     geom = container.geometry
#     area = geom.width*geom.height
#     print("area:", area)
#     if area < FLOATING_TRESHOLD:
#         pprint(vars(container))
#         ipc.command("floating enable")
#     focused_container = ipc.get_tree().find_focused()
#     # Doesn't work either
#     if (
#         area < FLOATING_TRESHOLD
#         and focused_container.id == container.id
#         and focused_container.type != "floating_con"
#     ):
#         ipc.command("floating toggle")
#         # if focused_container.id == container.id:
#         #     # Just focus it
#         #     ipc.command("floating toggle")
#         # else:
#         #     # Focus new window, float it, then focus back
#         #     ipc.command(f"[id=\"{container.id}\"] focus")
#         #     ipc.command("floating toggle")
#         #     ipc.command(f"[id=\"{focused_container.id}\"] focus")

if __name__ == "__main__":
    ipc = Connection()
    focused = ipc.get_tree().find_focused()
    if focused is not None:
        prev_focused = focused.id
    ipc.on(Event.WINDOW_FOCUS, focus_handler)
    ipc.on(Event.WINDOW_CLOSE, close_handler)
    # ipc.on(Event.WINDOW_FOCUS, autofloating_handler)
    ipc.main()
