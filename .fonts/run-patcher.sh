#!/bin/bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 <dest_dir> [font_file...]" >&2
	echo "For example: $0 roboto-mono-nerd /usr/share/fonts/TTF/RobotoMono-{Regular,Medium,Bold,Italic}.ttf" >&2
	exit 1
fi

dest_dir=$1
shift

if [[ -d "$dest_dir" ]]; then
	echo "Output directory exists." >&2
	exit 1
fi

mkdir -pv "$dest_dir"
src_dir="$(mktemp -d)"
cp -v "$@" "$src_dir"

docker run \
	-v "${src_dir}:/in" \
	-v "$PWD/$dest_dir:/out" --rm \
	--user="$(id -u):$(id -g)" \
	nerdfonts/patcher:latest -c

rm -rv "$src_dir"
