#!/usr/bin/env python
from i3ipc import Connection, Event, events


DEFAULT_LAYOUT_INDEX = 0


class Handler:
    def __init__(self, ipc):
        self.ipc = ipc
        self.windows = {}
        self.prev_focused = None
        if (focused := ipc.get_tree().find_focused()) is not None:
            self.prev_focused = focused.id
        ipc.on(Event.WINDOW_FOCUS, self.focus_handler)
        ipc.on(Event.WINDOW_CLOSE, self.close_handler)
        ipc.on(Event.WORKSPACE_INIT, self.workspace_init_handler)

    def _get_inputs(self):
        return [inp for inp in self.ipc.get_inputs() if inp.type == "keyboard"]

    def focus_handler(self, ipc, event: events.WindowEvent):
        container_id = event.container.id
        inputs = self._get_inputs()
        input_layout_data = {}
        # Get current layout of every input
        for input in inputs:
            if (index := input.xkb_active_layout_index) is not None:
                input_layout_data[input.identifier] = index

        if self.prev_focused is not None and self.prev_focused != container_id:
            self.windows[self.prev_focused] = input_layout_data

        cached_layout_data = self.windows.get(container_id, None)
        if cached_layout_data is not None:
            # Switch layout if it doesn't match cached window settings
            for input_id, layout_index in cached_layout_data.items():
                if layout_index != input_layout_data.get(input_id, None):
                    ipc.command(
                        f"input \"{input_id}\" xkb_switch_layout "
                        f"{layout_index}"
                    )
        else:
            # If window is new, switch to default layout
            for input in inputs:
                if input.xkb_active_layout_index != DEFAULT_LAYOUT_INDEX:
                    ipc.command(
                        f"input \"{input.identifier}\" xkb_switch_layout "
                        f"{DEFAULT_LAYOUT_INDEX}"
                    )
        self.prev_focused = container_id

    def close_handler(self, ipc, event):
        self.windows.pop(event.container.id, None)

    def workspace_init_handler(self, ipc: Connection, event: events.WorkspaceEvent):
        for input in self._get_inputs():
            ipc.command(
                f"input \"{input.identifier}\" xkb_switch_layout "
                f"{DEFAULT_LAYOUT_INDEX}"
            )


if __name__ == "__main__":
    ipc = Connection()
    Handler(ipc)
    ipc.main()
