#!/usr/bin/env python
import json
import msgpack
import os
import re
import requests
import time

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
            obj = {"full_text": "䀘 " + ", ".join(states), "urgent": True}
            print(json.dumps(obj))
        else:
            print(json.dumps({"full_text": ""}))
        time.sleep(30)
    except Exception:
        time.sleep(5)
