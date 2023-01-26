#!/bin/bash

update () {
	echo "foo $1"
}

trap "update 123" SIGALRM

while sleep 1; do
	update
done

# get_json_str() {
# 	time=$(date +"%x %X")
# 	right='{"full_text": "'$time'", "align": "right"}'
# 	echo "[${left}, ${right}],"
# }

# echo '{"version": 1, "click_events": true}'
# echo '['
# while true; do
# 	get_json_str
# 	sleep 1
# done
