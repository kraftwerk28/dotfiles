#!/usr/bin/env python
import requests
import os
import sys
import time


ICONS = {
    "01d": " ",
    "01n": " ",
    "02d": " ",
    "02n": " ",
    "03d": " ",
    "03n": " ",
    "04d": " ",
    "04n": " ",
    "09d": " ",
    "09n": " ",
    "10d": " ",
    "10n": " ",
    "11d": " ",
    "11n": " ",
    "13d": " ",
    "13n": " ",
    "50d": " ",
    "50n": " ",
}


def get_geo():
    url = "http://ip-api.com/json"
    resp = requests.get(url)
    json = resp.json()
    return json["lat"], json["lon"]


def get_response(app_id, location=None):
    url = "https://api.openweathermap.org/data/2.5/weather"
    params = {"appid": app_id, "units": "metric"}
    if location is None:
        lat, lon = get_geo()
        params.update({"lat": lat, "lon": lon})
    else:
        params["q"] = location
    return requests.get(url, params=params)


def get_weather_string(app_id, location=None):
    resp = get_response(app_id, location)
    data = resp.json()
    temperature = int(data["main"]["temp"])
    ret = f" {temperature}"
    if data["weather"]:
        condition = data["weather"][0]["main"]
        icon_id = data["weather"][0]["icon"]
        ret += f" {ICONS.get(icon_id,'')}{condition}"
    return ret


def get_browser_url(app_id, location=None):
    json = get_response(app_id, location).json()
    id = json["id"]
    return f"https://openweathermap.org/city/{id}"


def get_weather_in_loop(token, location):
    while True:
        print("Damn")
        t_start = time.time()
        print(get_weather_string(token, location))
        # if (t := 5 * 60 - (time.time() - t_start)) > 0:
        #     time.sleep(t)


if __name__ == "__main__":
    while True:
        print(str(time.time()))

    # if (token := os.getenv("OPENWEATHER_APP_ID")) is None:
    #     print("OPENWEATHER_APP_ID is not defined")
    #     sys.exit(1)
    # try:
    #     location = os.getenv("OPENWEATHER_LOCATION")
    #     if len(sys.argv) >= 2 and sys.argv[1] == "open":
    #         os.system(f"xdg-open {get_browser_url(token, location)}")
    #     else:
    #         get_weather_in_loop(token, location)
    # except Exception as e:
    #     raise e
