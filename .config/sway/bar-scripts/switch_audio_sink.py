#!/usr/bin/env python
import sys
import asyncio
try:
    import pulsectl_asyncio as pa
except ImportError:
    import os
    os.execvp(
        "notify-send",
        ["notify-send", "Import error", "Please install pulsectl-asyncio"]
    )


async def switch_sink(p: pa.PulseAsync):
    def_name = (await p.server_info()).default_sink_name
    sinks = await p.sink_list()
    sink_index = [s.name for s in sinks].index(def_name)
    sink = sinks[sink_index]
    port_names = [p.name for p in sink.port_list]
    current_port_index = port_names.index(sink.port_active.name)
    if current_port_index == len(sink.port_list) - 1:
        new_sink = sinks[(sink_index + 1) % len(sinks)]
        new_port = new_sink.port_list[0]
        await p.sink_default_set(new_sink)
        await p.sink_port_set(new_sink.index, new_port.name)
    else:
        new_port = sink.port_list[current_port_index + 1]
        await p.sink_port_set(sink.index, new_port.name)


async def get_current_sink_icon(p: pa.PulseAsync):
    sink_name = (await p.server_info()).default_sink_name
    sink = await p.get_sink_by_name(sink_name)
    port = sink.port_active
    icon = port.description.lower()
    print('{{"icon": "{}", "text": "foo"}}'.format(icon))


async def subscribe(p: pa.PulseAsync):
    async for event in p.subscribe_events("sink"):
        await get_current_sink_icon(p)


async def main():
    arg = "next" if len(sys.argv) < 2 else sys.argv[1]
    async with pa.PulseAsync(f"pulsectl-script-{arg}") as p:
        if arg == "subscribe":
            print(r"""{"icon": "headset", "text": ""}""")
            # await subscribe(p)
        elif arg == "next":
            await switch_sink(p)

if __name__ == "__main__":
    asyncio.run(main())
