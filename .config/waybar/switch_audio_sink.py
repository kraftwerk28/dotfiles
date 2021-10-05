#!/usr/bin/env python
import subprocess as sp
import re
from typing import List


def parse(output: List[str]) -> List[str]:
    sink_id = 0
    ports = []
    current_port = ""
    flag = False
    for line in output:
        if (m := re.search(r"Sink #(\d+)", line)) is not None:
            sink_id = m[1]
        if (m := re.search(r"Active Port: ([\w-]+)", line)) is not None:
            current_port = m[1]
            continue
        if flag:
            if (m := re.search(r"\t\t([\w-]+)", line)) is not None:
                ports.append(m[1])
            else:
                flag = False
        if re.search(r"Ports:$", line) is not None:
            flag = True
    return ports, current_port, sink_id


if __name__ == "__main__":
    proc = sp.run(["pactl", "list", "sinks"], stdout=sp.PIPE)
    output_lines = [line.decode() for line in proc.stdout.splitlines()]
    ports, current_port, sink_id = parse(output_lines)
    next_port = ports[(ports.index(current_port) + 1) % len(ports)]
    sp.call(["pactl", "set-sink-port", sink_id, next_port])
