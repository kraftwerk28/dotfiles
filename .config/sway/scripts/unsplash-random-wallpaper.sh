#!/bin/bash
# TODO: uncompleted

unsplash_url="https://unsplash.com/s/photos/wallpaper?orientation=landscape"
pic_file="/tmp/unsplash_wallpaper"
url=$(curl -s "$unsplash_url" | htmlq -a src 'figure img' | shuf -n 1)
curl -s -o $pic_file "$url"
swaymsg "output * bg $pic_file fill"
