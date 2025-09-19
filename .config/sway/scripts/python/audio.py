import json
import subprocess


class PulseControl:
    def __init__(self, volume_step=5, max_volume=100):
        self._volume_step = volume_step
        self._max_volume = max_volume
        self._notify_timeout_ms = 2000

    def _pactl(self, *args):
        return subprocess.run(["pactl", *args], text=True, stdout=subprocess.PIPE)

    def _get_sinks(self):
        raw = self._pactl("-f", "json", "list", "sinks")
        return json.loads(raw.stdout)

    def _get_default_sink(self):
        return self._pactl("get-default-sink").stdout.strip()

    def get_volume(self, sink_name: str) -> tuple[int, bool]:
        try:
            sink = next(s for s in self._get_sinks() if s["name"] == sink_name)
            volumes = [int(p["value_percent"][:-1]) for p in sink["volume"].values()]
            volume = sum(volumes) // len(volumes)
            muted = sink["mute"]
            return volume, muted
        except Exception:
            return 0, False

    def _notify(self, volume: int, muted: bool):
        icon = " " if muted else " "
        percent = min(volume, 100)
        cmd = [
            "notify-send",
            "--transient",
            "--category=progress",
            "--hint=string:x-canonical-private-synchronous:volume",
            f"--hint=int:value:{percent}",
            f"--expire-time={self._notify_timeout_ms}",
            f"{icon} {percent}%",
        ]
        subprocess.run(cmd)

    def _calc_volume(self, volume: int, diff: int):
        ret = volume + diff
        ret = round(ret / diff) * diff
        return min(max(ret, 0), self._max_volume)

    def set_mic_mute(self, mute: bool):
        self._pactl("set-source-mute", "@DEFAULT_SOURCE@", "1" if mute else "0")

    def toggle_mic(self):
        self._pactl("set-source-mute", "@DEFAULT_SOURCE@", "toggle")

    def toggle_speaker(self):
        self._pactl("set-sink-mute", "@DEFAULT_SINK@", "toggle")
        volume, muted = self.get_volume(self._get_default_sink())
        self._notify(volume, muted)

    def _change_volume(self, dir: int):
        sink = self._get_default_sink()
        volume, muted = self.get_volume(sink)
        if "Focusrite" in sink:
            self._notify(volume, muted)
            return
        if dir > 0:
            volume = self._calc_volume(volume, diff=1 if volume < 5 else 5)
        elif dir < 0:
            volume = self._calc_volume(volume, diff=-1 if volume <= 5 else -5)
        else:
            return
        self._pactl("set-sink-volume", "@DEFAULT_SINK@", f"{volume}%")
        self._notify(volume, muted)

    def volume_up(self):
        return self._change_volume(1)

    def volume_down(self):
        return self._change_volume(-1)
