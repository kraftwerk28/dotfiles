#!/bin/bash
#
# Convert a video file to suitable format for Telegram video stickers.
# See: https://core.telegram.org/stickers#video-stickers
# If the video stream has duration larger than required, it will be sped up
# to match 3 seconds.
# Script needs ffmpeg, ffprobe and jq to work
#
set -e

MAX_DURATION=3
TARGET_DIMENSION=512
TARGET_FPS=30
MAX_FILE_SIZE=$((1024*256))

usage() {
	echo "Usage: $0 <input> [output]" >&2
	exit 1
}

[[ $# -eq 0 ]] && usage
in_file="$1"
out_file="${2:-"${1%.*}.webm"}"

dur_s=$(ffprobe -v quiet -show_format -of json "$in_file" | jq -r '.format.duration')
speed_filter=$(jq -nr --argjson d "$dur_s" --argjson max $MAX_DURATION \
	'if $d > $max then "setpts=PTS*\(($max / $d)*1e5 | round | ./1e5)" else "" end')
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
	-an \
	-fs "$MAX_FILE_SIZE" \
	"$out_file"

# # TODO
# target_bitrate="$(jq -nr --arg d $TARGET_DURATION --arg s $TARGET_SIZE '($s | tonumber) / ($d | tonumber)')k"
#
# ffmpeg -hide_banner -y \
# 	-i "$in_file" \
# 	-c:v libvpx-vp9 \
# 	-vf "$vfilter" \
# 	-b:v "$target_bitrate" \
# 	-an \
# 	-pass 1 \
# 	-f null /dev/null
# ffmpeg -hide_banner -y \
# 	-i "$in_file" \
# 	-c:v libvpx-vp9 \
# 	-vf "$vfilter" \
# 	-b:v "$target_bitrate" \
# 	-an \
# 	-pass 2 \
# 	"$out_file"
