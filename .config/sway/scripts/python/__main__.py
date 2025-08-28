from dataclasses import dataclass

from i3ipc import (
    Connection,
    Event,
    WindowEvent,
    BindingEvent,
    WorkspaceEvent,
    OutputReply,
)

from .audio import PulseControl


@dataclass
class OutputMatch:
    top: int
    left: int
    match: dict[str, str | int]

    def suits(self, output: OutputReply):
        return all(getattr(output, k) == v for k, v in self.match.items())

    def command(self, output: OutputReply):
        return f"output {output.name} position {self.left} {self.top}"


OUTPUT_LAYOUTS = [
    [
        OutputMatch(match={"model": "0x149A"}, top=360, left=2560),
        OutputMatch(match={"model": "DELL P2720DC"}, top=0, left=0),
    ],
    [
        OutputMatch(match={"model": "0x149A"}, top=120, left=1920),
        OutputMatch(match={"model": "LF24T450G"}, top=0, left=0),
    ],
]


class Scripting:
    DEFAULT_KBD_LAYOUT_ID = 0

    def __init__(self):
        self.prev_con_id: int | None = None
        self.prev2_con_id: int | None = None  # Used for back-and-forth switching
        self.layout_cache: dict[int, dict[int, int]] = {}
        self.ignore_next_output_event = False
        self.volume = PulseControl()

        i3 = Connection()
        i3.on(Event.WINDOW_FOCUS, self.on_win_focus)
        i3.on(Event.WINDOW_CLOSE, self.on_win_close)
        i3.on(Event.WORKSPACE_INIT, self.on_ws_init)
        i3.on(Event.BINDING, self.on_binding)
        i3.on(Event.OUTPUT, self.on_output)
        self.i3 = i3

    def switch_to_default_kbd_layout(self):
        cmd = ", ".join(
            f"input {inp.identifier} xkb_switch_layout {self.DEFAULT_KBD_LAYOUT_ID}"
            for inp in self.i3.get_inputs()
            if inp.type == "keyboard"
        )
        self.i3.command(cmd)

    def on_win_focus(self, ipc: Connection, ev: WindowEvent):
        # Remember layouts for previous Con
        if self.prev_con_id != ev.container.id:
            self.layout_cache[self.prev_con_id] = {
                inp.identifier: inp.xkb_active_layout_index
                for inp in ipc.get_inputs()
                if inp.type == "keyboard"
            }
        self.prev2_con_id = self.prev_con_id
        self.prev_con_id = ev.container.id
        if layouts := self.layout_cache.get(ev.container.id):
            # Set layout if current Con is in cache
            cmd = ", ".join(
                f"input {input_id} xkb_switch_layout {layout_id}"
                for input_id, layout_id in layouts.items()
            )
            ipc.command(cmd)
        else:
            # Otherwise set the default layout
            self.switch_to_default_kbd_layout()

    def on_win_close(self, _: Connection, ev: WindowEvent):
        self.layout_cache.pop(ev.container.id, None)

    def on_ws_init(self, ipc: Connection, _: WorkspaceEvent):
        self.prev2_con_id = self.prev_con_id
        cmds = [
            f"input {inp.identifier} xkb_switch_layout {self.DEFAULT_KBD_LAYOUT_ID}"
            for inp in ipc.get_inputs()
            if inp.type == "keyboard"
        ]
        ipc.command(", ".join(cmds))

    def on_binding(self, ipc: Connection, ev: BindingEvent):
        cmd = ev.binding.command
        if cmd == "nop focus_prev" and self.prev2_con_id is not None:
            # Focus previous container
            cmd = f"[con_id={self.prev2_con_id}] focus"
            ipc.command(cmd)
        elif cmd.startswith("nop workspace"):
            # Switch to Nth workspace
            wss = ipc.get_workspaces()
            focused_ws = next((ws for ws in wss if ws.focused), None)
            if focused_ws is None:
                return
            if cmd.endswith("prev"):
                ws_num = focused_ws.num - 1
            elif cmd.endswith("next"):
                ws_num = focused_ws.num + 1
            else:
                return
            if ws_num > 0:
                ipc.command(f"workspace {ws_num}")
        elif cmd.startswith("nop volume"):
            parts = cmd.split()
            if len(parts) > 2:
                self.volume.handle_cmd(*parts[2:])
        elif "rofi" in cmd:
            self.switch_to_default_kbd_layout()

    def on_output(self, ipc, ev):
        self.adjust_outputs()

    def adjust_outputs(self):
        if self.ignore_next_output_event:
            self.ignore_next_output_event = False
            return
        outputs = self.i3.get_outputs()
        for layout in OUTPUT_LAYOUTS:
            try:
                commands = []
                for match in layout:
                    output = next(o for o in outputs if match.suits(o))
                    commands.append(match.command(output))
                self.i3.command(", ".join(commands))
                self.ignore_next_output_event = True
                break
            except:
                pass

    def main(self):
        self.adjust_outputs()
        self.i3.main()


if __name__ == "__main__":
    Scripting().main()
