#!/usr/bin/env python
import msgpack
import requests
import re
import time
import os

while True:
    try:
        locs = requests.get("https://alerts.in.ua/assets/locations.json").json()
        break
    except Exception:
        time.sleep(5)

name_re = os.getenv("ALERTS_LOC_REGEX") or r".*"

while True:
    try:
        res = requests.get("https://api.alerts.in.ua/v3/alerts/active.mp")
        d = msgpack.unpackb(res.content)
        states = []
        for alert in d.get("alerts", []):
            if (ind := alert.get("ni", None)) is None:
                continue
            loc = locs[ind]
            statename = loc.get("title", None)
            if re.search(name_re, statename, flags=re.IGNORECASE):
                states.append(re.sub(r" область$", "", statename))
        if states:
            text = ", ".join(states)
            print('{"full_text": "䀘 ' + text + '", "urgent": true}', flush=True)
        else:
            print('{"full_text": ""}', flush=True)
        time.sleep(30)
    except Exception:
        time.sleep(5)
