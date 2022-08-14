#!/usr/bin/env python
import json
import msgpack
import os
import re
import requests
import time

name_re = re.compile(os.getenv("ALERTS_LOC_REGEX") or r".*", re.IGNORECASE)
state_re = re.compile(r"\s+область$", re.IGNORECASE)

while True:
    try:
        r = requests.get(
            "https://alerts.in.ua/assets/locations.json",
            timeout=10,
        )
        locs = r.json()
        break
    except Exception:
        time.sleep(5)

while True:
    try:
        res = requests.get(
            "https://api.alerts.in.ua/v3/alerts/active.mp",
            timeout=10,
        )
        d = msgpack.unpackb(res.content)
        states = []
        for alert in d.get("alerts", []):
            if (ind := alert.get("ni", None)) is None:
                continue
            try:
                loc = locs[ind]
            except IndexError:
                continue
            statename = loc.get("title", None)
            if name_re.search(statename):
                states.append(state_re.sub("", statename))
        if states:
            obj = {"full_text": "䀘 " + ", ".join(states), "urgent": True}
            print(json.dumps(obj), flush=True)
        else:
            print(json.dumps({"full_text": ""}), flush=True)
        time.sleep(30)
    except Exception:
        time.sleep(5)
