from dataclasses import dataclass
import time
import logging
from i3ipc import (
    Connection,
    Event,
    WindowEvent,
    BindingEvent,
    WorkspaceEvent,
    OutputReply,
)
from .audio import PulseControl

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()


@dataclass
class OutputConfig:
    match: dict[str, str | int]
    pos: tuple[int, int] | None = None
    scale: float | None = None
    enabled: bool | None = None
    size: tuple[int, int] | Noe = None
    fps: int | None = None

    def suits(self, output: OutputReply):
        return all(
            (
                output["rect"]["width"] == value
                if key == "width"
                else (
                    output["rect"]["height"] == value
                    if key == "height"
                    else getattr(output, key) == value
                )
            )
            for key, value in self.match.items()
        )

    def get_commands_for(self, output: OutputReply) -> str | None:
        cmds = []
        if self.pos is not None:
            x, y = self.pos
            cmds.append(f"position {x} {y}")
        if self.scale is not None:
            cmds.append(f"scale {self.scale}")
        if self.enabled is not None:
            cmds.append("enable" if self.enabled else "disable")
        if self.size is not None:
            w, h = self.size
            rate_hz = "" if self.fps is None else f"@{self.fps}"
            cmds.append(f"mode {w}x{h}{rate_hz}")
        if cmds:
            return f"output {output.name} " + " ".join(cmds)


OUTPUT_LAYOUTS: list[list[OutputConfig]] = [
    [
        OutputConfig(match={"model": "0x149A"}, pos=(2560, 360)),
        OutputConfig(match={"model": "DELL P2720DC"}, pos=(0, 0)),
    ],
    [
        OutputConfig(match={"model": "0x149A"}, pos=(1920, 120)),
        OutputConfig(match={"model": "LF24T450G"}, pos=(0, 0)),
    ],
    [
        OutputConfig(match={"model": "DELL U2718Q"}, scale=1.6, pos=(0, 0)),
        OutputConfig(match={"model": "0x149A"}, enabled=False),
    ],
    [
        OutputConfig(
            match={
                "model": "StudioDisplay",
                "serial": "0x13311782",
                "name": "DP-1",
            },
            pos=(0, 0),
            scale=1.4,
        ),
        OutputConfig(
            match={
                "model": "StudioDisplay",
                "serial": "0x13311782",
                "name": "DP-2",
            },
            enabled=False,
        ),
        OutputConfig(match={"model": "0x149A"}, enabled=False),
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
        self.last_outp_ev_time: float | None = None

        i3 = Connection()
        i3.on(Event.WINDOW_FOCUS, self.on_win_focus)
        i3.on(Event.WINDOW_CLOSE, self.on_win_close)
        i3.on(Event.WORKSPACE_INIT, self.on_ws_init)
        i3.on(Event.BINDING, self.on_binding)
        i3.on(Event.OUTPUT, self.on_output)
        # i3.on(Event.SHUTDOWN, self.on_shutdown)
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

    def _handle_nop_cmd(self, words: list[str]):
        match words:
            case "focus_prev",:
                if self.prev2_con_id is not None:
                    # Focus previous container
                    self.i3.command(f"[con_id={self.prev2_con_id}] focus")
            case "workspace", action:
                # Switch to Nth workspace
                wss = self.i3.get_workspaces()
                focused_ws = next((ws for ws in wss if ws.focused), None)
                if focused_ws is None:
                    return
                if action == "prev":
                    ws_num = focused_ws.num - 1
                elif action == "next":
                    ws_num = focused_ws.num + 1
                else:
                    return
                if ws_num > 0:
                    self.i3.command(f"workspace {ws_num}")
            case "volume", "mic-mute":
                self.volume.set_mic_mute(True)
            case "volume", "mic-unmute":
                self.volume.set_mic_mute(False)
            case "volume", "mic-toggle":
                self.volume.toggle_mic()
            case "volume", "speaker-toggle":
                self.volume.toggle_speaker()
            case "volume", "up":
                self.volume.volume_up()
            case "volume", "down":
                self.volume.volume_down()

    def on_binding(self, ipc: Connection, ev: BindingEvent):
        cmd_raw = ev.binding.command
        if cmd_raw.startswith("nop "):
            parts = cmd_raw.split()[1:]
            self._handle_nop_cmd(parts)
        elif "rofi" in cmd_raw:
            self.switch_to_default_kbd_layout()

    def on_output(self, ipc, ev):
        now = time.time()
        if (self.last_outp_ev_time is None) or (now - self.last_outp_ev_time >= 1):
            self.adjust_outputs()
        self.last_outp_ev_time = now

    def on_shutdown(self, ipc: Connection, ev: BindingEvent):
        self.i3.main_quit()

    def adjust_outputs(self):
        log.info("Adjusting outputs")
        outputs = self.i3.get_outputs()
        untouched_outputs = set(outputs)
        try:
            # Find the layout, where all Matches match at least one output
            layout = next(
                layout
                for layout in OUTPUT_LAYOUTS
                if all(any(m.suits(o) for o in outputs) for m in layout)
            )
            log.info("Matched output layout: %s", layout)
            for match in layout:
                output = next(o for o in outputs if match.suits(o))
                untouched_outputs.remove(output)
                if cmd := match.get_commands_for(output):
                    log.info("Running output cmd: '%s'", cmd)
                    self.i3.command(cmd)
        except StopIteration:
            pass

        # Enable any outputs that may be left disabled by the script in
        # previous adjustments
        for output in untouched_outputs:
            cmd = f"output {output.name} enable"
            log.info("Running output cmd: '%s'", cmd)
            self.i3.command(cmd)

    def main(self):
        self.adjust_outputs()
        self.i3.main()


if __name__ == "__main__":
    s = Scripting()
    s.main()
