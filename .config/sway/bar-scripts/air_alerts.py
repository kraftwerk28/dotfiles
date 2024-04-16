import json, os, re, time, msgpack, requests

name_re = re.compile(os.getenv("ALERTS_LOC_REGEX") or r".*", re.IGNORECASE)
state_re = re.compile(r"\s+область$", re.IGNORECASE)
latest_alert_states = None

ALERTS_URL = "https://api.alerts.in.ua/v3/alerts/active.mp"
LOCATIONS_URL = "https://alerts.in.ua/assets/locations.json"


def output(alert_states=None, loading=False):
    global latest_alert_states
    if alert_states == []:
        obj = {"full_text": "䀘", "color": "#00ff00", "urgent": False}
    elif alert_states and not loading:
        text = "䀘 " + ", ".join(alert_states)
        obj = {"full_text": text, "urgent": True}
    elif loading and latest_alert_states:
        text = "䀘 " + ", ".join(latest_alert_states) + "  "
        obj = {"full_text": text, "urgent": True}
    else:
        obj = {"full_text": "䀘  ", "urgent": False}
    if alert_states != latest_alert_states:
        latest_alert_states = alert_states
    print(json.dumps(obj))


while True:
    try:
        r = requests.get(LOCATIONS_URL, timeout=10)
        locs = r.json()
        break
    except Exception:
        output(loading=True)
        time.sleep(5)


with open("locations.json") as f:
    locations = json.load(f)
with open("active.mp", "rb") as f:
    resp_dict = msgpack.unpackb(f.read())
    alerts = [(a, locations[a["ni"]]) for a in resp_dict["alerts"] if a["t"] == "o"]
    print(json.dumps(alerts))


# while True:
#     try:
#         resp = requests.get(ALERTS_URL, timeout=10)
#         resp_dict = msgpack.unpackb(resp.content)
#         states = []
#         for alert in resp_dict.get("alerts", []):
#             try:
#                 state_index = alert["ni"]
#                 state = locs[state_index]
#                 statename = state["title"]
#             except:
#                 continue
#             if name_re.search(statename):
#                 states.append(state_re.sub("", statename))
#         output(states)
#         time.sleep(30)
#     except Exception:
#         output(loading=True)
#         time.sleep(5)
