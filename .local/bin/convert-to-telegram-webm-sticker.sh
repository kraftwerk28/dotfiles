#!/bin/bash
#
# Convert a video file to suitable format for Telegram video stickers.
# See: https://core.telegram.org/stickers#video-stickers
# If the video stream has duration larger than required, it will be sped up
# to match 3 seconds.
# Script needs ffmpeg, ffprobe and jq to work
#
set -e

TARGET_DURATION_S=3
TARGET_DIMENSION_PX=512
TARGET_FPS=30
TARGET_SIZE=2020

usage() {
	echo "Usage: $0 <input> [output]" >&2
	exit 1
}

if [[ $# -le 1 ]]; then
	in_file="$1"
	out_file="${1%.*}.webm"
elif [[ $# -le 2 ]]; then
	in_file="$1"
	out_file="$2"
else
	usage
fi

# Export variables for jq commands
export TARGET_SIZE TARGET_DURATION_S

duration_mul=$(ffprobe -v quiet -show_format -of json "$in_file" | jq -r \
	' (env.TARGET_DURATION_S | tonumber) as $d
	| .format.duration | tonumber
	| if . > $d then $d / . else 1 end')
scale="w=${TARGET_DIMENSION_PX}:h=${TARGET_DIMENSION_PX}:force_original_aspect_ratio=decrease"
target_bitrate="$(jq -nr '(env.TARGET_SIZE | tonumber) / (env.TARGET_DURATION_S | tonumber)')k"
vfilter="setpts=${duration_mul}*PTS,fps=${TARGET_FPS},scale=${scale}"

set -x
ffmpeg -hide_banner -y -i "$in_file" -c:v libvpx-vp9 -pix_fmt yuva420p -vf "$vfilter" \
	-b:v "$target_bitrate" -an -pass 1 -f null /dev/null
ffmpeg -hide_banner -i "$in_file" -c:v libvpx-vp9 -pix_fmt yuva420p -vf "$vfilter" \
	-b:v "$target_bitrate" -an -pass 2 "${out_file}"
