#!/usr/bin/python

from i3ipc import Connection, Event
from i3ipc.events import BindingEvent, WindowEvent, InputEvent

DEFAULT_LAYOUT_ID = 0

prev_id: int | None = None
cur_id: int | None = None
layouts: dict[int, dict[int, int]] = {}
i3 = Connection()


def on_win_focus(ipc: Connection, ev: WindowEvent):
    global prev_id, cur_id
    prev_id = cur_id
    cur_id = ev.container.id

    if prev_id is not None:
        layouts[prev_id] = {
            i.identifier: i.xkb_active_layout_index
            for i in ipc.get_inputs()
            if i.type == "keyboard"
        }
    if cur_win_inputs := layouts.get(ev.container.id):
        cmd = ", ".join(
            f"input {input_id} xkb_switch_layout {layout_id}"
            for input_id, layout_id in cur_win_inputs.items()
        )
        ipc.command(cmd)

    else:
        cmd = ", ".join(
            f"input {i.identifier} xkb_switch_layout {DEFAULT_LAYOUT_ID}"
            for i in ipc.get_inputs()
            if i.type == "keyboard"
        )
        ipc.command(cmd)


def on_win_close(ipc: Connection, ev: WindowEvent):
    del layouts[ev.container.id]
    print(layouts)


def on_binding(ipc: Connection, ev: BindingEvent):
    words = ev.binding.command.split()
    if words == ["nop", "focus_prev"] and prev_id is not None:
        i3.command(f"[con_id={prev_id}] focus")


i3.on(Event.WINDOW_FOCUS, on_win_focus)
i3.on(Event.WINDOW_CLOSE, on_win_close)
i3.on(Event.BINDING, on_binding)
i3.main()
