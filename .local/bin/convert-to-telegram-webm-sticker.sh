#!/bin/bash
#
# Convert a video file to suitable format for Telegram video stickers.
# See: https://core.telegram.org/stickers#video-stickers
# If the video stream has duration larger than required, it will be sped up
# to match 3 seconds.
# Script needs ffmpeg, ffprobe and jq to work
#
set -e

usage() {
	echo "Usage: $0 [-m trim|shrink] <input> [output]" >&2
	exit 1
}

MAX_DURATION=3
TARGET_DIMENSION=512
TARGET_FPS=30

# NOTE: set the size slightly less than 256k, otherwise it may be a bit larger
# (i.e. 2560k), I dunno why
MAX_FILE_SIZE=$((1024*256 - 4*1024))

# Can be `shrink` or `trim`
SHORTEN_MODE="shrink"

while [[ $# -gt 0 ]]; do
	case $1 in
		-h) usage;;
		-m)
			SHORTEN_MODE=$2
			shift 2
			;;
		*)
			if [[ -z $in_file ]]; then
				in_file="$1"
			else
				out_file="$1"
			fi
			shift
			;;
	esac
done

: "${out_file:="${in_file%.*}.webm"}"

case "$SHORTEN_MODE" in
	shrink|trim);;
	*) usage;;
esac
[[ -z $in_file || -z $out_file ]] && usage

format_json="$(ffprobe -v quiet -show_format -of json "$in_file")"
duration=$(jq -r '.format.duration' <<< "$format_json")
# bitrate=$(jq -r '.format.bit_rate' <<< "$format_json")

target_bitrate=$(jq -nr --argjson d "$duration" --argjson dmax "$MAX_DURATION" --argjson smax "$MAX_FILE_SIZE" \
	'$smax * 8 / ([$d, $dmax] | min) | floor')
if [[ $SHORTEN_MODE == "trim" ]]; then
	speed_filter="trim=duration=$MAX_DURATION"
else
	speed_filter=$(jq -nr --argjson d "$duration" --argjson dmax $MAX_DURATION \
		'if $d > $dmax then "setpts=PTS*\(($dmax / $d)*1e5 | round | ./1e5)" else "" end')
fi
scale_filter="scale=w=$TARGET_DIMENSION:h=$TARGET_DIMENSION:force_original_aspect_ratio=decrease"
fps_filter="fps=$TARGET_FPS"

vfilter="$scale_filter,$fps_filter"
if [[ -n $speed_filter ]]; then
	vfilter="$speed_filter,$vfilter"
fi

set -x

ffmpeg -hide_banner -y \
	-i "$in_file" \
	-c:v libvpx-vp9 \
	-vf "$vfilter" \
	-b:v "$target_bitrate" \
	-an \
	-pass 1 \
	-f webm \
	/dev/null

ffmpeg -hide_banner -y \
	-i "$in_file" \
	-c:v libvpx-vp9 \
	-vf "$vfilter" \
	-b:v "$target_bitrate" \
	-an \
	-pass 2 \
	-f webm \
	"$out_file"
