#!/usr/bin/python

from i3ipc import Connection, Event
from i3ipc.events import BindingEvent, WindowEvent, WorkspaceEvent

DEFAULT_LAYOUT_ID = 0

prev_con_id: int | None = None
prev2_con_id: int | None = None  # Used for back-and-forth switching
layout_cache: dict[int, dict[int, int]] = {}
i3 = Connection()


def on_win_focus(ipc: Connection, ev: WindowEvent):
    global prev_con_id, prev2_con_id
    # Remember layouts for previous Con
    if prev_con_id != ev.container.id:
        layout_cache[prev_con_id] = {
            inp.identifier: inp.xkb_active_layout_index
            for inp in ipc.get_inputs()
            if inp.type == "keyboard"
        }
    prev2_con_id = prev_con_id
    prev_con_id = ev.container.id
    if layouts := layout_cache.get(ev.container.id):
        # Set layout if current Con is in cache
        cmds = [
            f"input {input_id} xkb_switch_layout {layout_id}"
            for input_id, layout_id in layouts.items()
        ]
        ipc.command(", ".join(cmds))
    else:
        # Otherwise set the default layout
        cmds = [
            f"input {inp.identifier} xkb_switch_layout {DEFAULT_LAYOUT_ID}"
            for inp in ipc.get_inputs()
            if inp.type == "keyboard"
        ]
        ipc.command(", ".join(cmds))


def on_win_close(_: Connection, ev: WindowEvent):
    layout_cache.pop(ev.container.id, None)


def on_ws_init(ipc: Connection, _: WorkspaceEvent):
    global prev2_con_id
    prev2_con_id = prev_con_id
    cmds = [
        f"input {inp.identifier} xkb_switch_layout {DEFAULT_LAYOUT_ID}"
        for inp in ipc.get_inputs()
        if inp.type == "keyboard"
    ]
    ipc.command(", ".join(cmds))


def on_binding(_: Connection, ev: BindingEvent):
    # NOTE: dumb splitting, w/o shlex
    words = ev.binding.command.split()
    if words == ["nop", "focus_prev"] and prev2_con_id is not None:
        cmd = f"[con_id={prev2_con_id}] focus"
        i3.command(cmd)


i3.on(Event.WINDOW_FOCUS, on_win_focus)
i3.on(Event.WINDOW_CLOSE, on_win_close)
i3.on(Event.WORKSPACE_INIT, on_ws_init)
i3.on(Event.BINDING, on_binding)
i3.main()
