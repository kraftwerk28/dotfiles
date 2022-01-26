#!/usr/bin/env python
import sys
try:
    import pulsectl
except ImportError:
    import os
    os.execvp(
        "notify-send",
        ["notify-send", "Import error", "Please install python-pulsectl"]
    )

if __name__ == "__main__":
    arg = "next" if len(sys.argv) < 2 else sys.argv[1]
    with pulsectl.Pulse("sink-switcher") as p:
        def_name = p.server_info().default_sink_name
        sinks = p.sink_list()
        sink_index = [s.name for s in sinks].index(def_name)
        sink = sinks[sink_index]
        current_port_index = [p.name for p in sink.port_list] \
            .index(sink.port_active.name)
        if current_port_index == len(sink.port_list) - 1:
            new_sink = sinks[(sink_index + 1) % len(sinks)]
            new_port = new_sink.port_list[0]
            p.sink_default_set(new_sink)
            p.sink_port_set(new_sink.index, new_port.name)
        else:
            new_port = sink.port_list[current_port_index + 1]
            p.sink_port_set(sink.index, new_port.name)
