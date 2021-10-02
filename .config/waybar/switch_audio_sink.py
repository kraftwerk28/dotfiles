#!/usr/bin/env python
import subprocess as sp

if __name__ == "__main__":
    proc = sp.run(["pactl", "list", "short", "sinks"], stdout=sp.PIPE)
    all_sinks = [s.split()[1] for s in proc.stdout.splitlines()]
    if len(all_sinks) < 2:
        exit()
    proc = sp.run(["pactl", "get-default-sink"], stdout=sp.PIPE)
    current_sink = proc.stdout.strip()
    next_sink = all_sinks[(all_sinks.index(current_sink) + 1) % len(all_sinks)]
    sp.call(["pactl", "set-default-sink", next_sink])
