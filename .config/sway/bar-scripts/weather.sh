#!/bin/bash
if [[ -z $OPENWEATHER_APP_ID ]]; then
	echo "OPENWEATHER_APP_ID is required." >&2
	exit 1
fi
while [[ $# -gt 0 ]]; do
	case "$1" in
		-o|--open) OPEN=1; shift;;
		-l|--location)
			shift
			LOCATION="$1"
			shift;;
		*)
			echo "Unknown param" >&2
			exit 1
			;;
	esac
done
qs="appid=${OPENWEATHER_APP_ID}&units=metric"
if [[ -z $LOCATION ]]; then
	loc=$(curl -fs "http://ip-api.com/json" \
		| jq -r '"lat=\(.lat)&lon=\(.lon)"')
	qs="${qs}&${loc}"
else
	qs="${qs}&q=${LOCATION}"
fi
url="https://api.openweathermap.org/data/2.5/weather?${qs}" 
if [[ -n $OPEN ]]; then
	xdg-open "https://openweathermap.org/city/$(curl -fs "$url" | jq '.id')"
else
	curl -fs "$url" \
		| jq -r \
		' (.main.temp * 10 | round | . / 10) as $temp
		| (if $ENV.LOCATION then "" else "\uf450 " end) as $icon
		| "\($icon)\($temp)° \(.weather[0].main)"'
fi
