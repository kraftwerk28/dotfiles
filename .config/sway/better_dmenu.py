#!/usr/bin/env python
from pathlib import Path
import re
import subprocess


def get_gtk_theme():
    from gi import require_version
    require_version("Gtk", "3.0")
    from gi.repository import Gtk
    return Gtk.IconTheme.get_default()


theme = get_gtk_theme()
ENTRY_SEP_RE = re.compile(r"\[Desktop.+\]")
ENTRY_ACTION_RE = re.compile(r"\[Desktop Action.+\]")
PROPERTY_RE = re.compile(r"^(name|icon|exec)=(.+)$", re.I)
ICON_SIZE = 24


def get_actions_from_file(path: Path):
    lines = path.read_text().splitlines()
    actions = []
    main_action = None
    line_idx = 0
    while line_idx < len(lines):
        line = lines[line_idx]
        is_action = False
        if re.search(ENTRY_SEP_RE, line) is not None:
            if re.search(ENTRY_ACTION_RE, line) is not None:
                is_action = True
            line_idx += 1
            entry = {}
            while (
                line_idx < len(lines)
                and re.search(ENTRY_SEP_RE, lines[line_idx]) is None
            ):
                line = lines[line_idx]
                if (m := re.search(PROPERTY_RE, line)) is not None:
                    key, val = m[1].lower(), m[2]
                    entry[key] = val
                line_idx += 1
            if is_action:
                actions.append(entry)
            else:
                main_action = entry
        else:
            line_idx += 1
    if main_action is None:
        # Invalid .desktop file
        return []
    for action in actions:
        if "icon" not in actions:
            action["icon"] = main_action["icon"]
        action["name"] = f"{main_action['name']} ({action['name']})"
    all_entries = [main_action, *actions]
    for entry in all_entries:
        if "icon" in entry:
            icon_info = theme.lookup_icon(entry["icon"], ICON_SIZE, 0)
            if icon_info is not None:
                icon_path = icon_info.get_filename()
                entry["wofi"] = f"img:{icon_path}:text:{entry['name']}"
            else:
                entry["wofi"] = entry["name"]
        else:
            entry["wofi"] = entry["name"]
    return all_entries


def iter_desktop_files():
    paths = [
        "/usr/share/applications",
        "/home/kraftwerk28/.local/share/applications"
    ]
    for dir_str in paths:
        p = Path(dir_str)
        for entry in p.glob("*.desktop"):
            if entry.is_file():
                yield entry


def get_entries():
    entries = []
    for entry in iter_desktop_files():
        entries += get_actions_from_file(entry)
    return entries


if __name__ == "__main__":
    wofi_proc = subprocess.Popen(
        ["wofi", "-d"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    entries = get_entries()
    byte_feed = "\n".join(entry["wofi"] for entry in entries).encode()
    stdout, stderr = wofi_proc.communicate(byte_feed)
    wofi_output = stdout.decode().strip()
    exec_match = (
        entry["exec"] for entry in entries
        if entry["wofi"] == wofi_output
    )
    if (exec := next(exec_match, None)) is not None:
        exec = re.sub(r"%[uf]", "", exec, flags=re.I)
        print(exec)
