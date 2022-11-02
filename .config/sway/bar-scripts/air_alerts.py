import json
import os
import re
import time

import msgpack
import requests

name_re = re.compile(os.getenv("ALERTS_LOC_REGEX") or r".*", re.IGNORECASE)
state_re = re.compile(r"\s+область$", re.IGNORECASE)
last_status = None


def out(states=None, loading=False):
    global last_status
    if states == []:
        obj = {"full_text": ""}
    elif states and not loading:
        obj = {"full_text": "䀘 " + ", ".join(states), "urgent": True}
    elif loading and last_status:
        obj = {"full_text": "䀘 " + ", ".join(last_status) + "  ", "urgent": True}
    else:
        obj = {"full_text": "䀘  "}
    if states != last_status:
        last_status = states
    print(json.dumps(obj))


while True:
    try:
        r = requests.get(
            "https://alerts.in.ua/assets/locations.json",
            timeout=10,
        )
        locs = r.json()
        break
    except Exception:
        out(loading=True)
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
        out(states)
        time.sleep(30)
    except Exception:
        out(loading=True)
        time.sleep(5)
