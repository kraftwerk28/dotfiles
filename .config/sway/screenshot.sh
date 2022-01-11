#!/bin/sh
WHAT=${1:-output}
if [[ $WHAT = "area" && $(pgrep slurp) ]]; then
	exit 0
fi
img_name="$HOME/Pictures/grimshot-$(date +"%x-%X").png"
fname=$(mktemp -u --suffix .png)

copy="wl-copy -n < \"$fname\";\
      notify-send \"Screenshot copied to clipboard\""
save="mv \"$fname\" \"$img_name\";\
      notify-send \"Screenshot saved to $img_name\""

if grimshot save "$WHAT" "$fname"; then
     swaynag 				     \
        -t warning 			     \
        -m "What to do with the screenshot?" \
        -y overlay 			     \
        -Z Copy "$copy" 		     \
        -Z Save "$save" 		     \
        -Z Edit "swappy -f "$fname"" 	     \
        --no-dock
else
        exit 0
fi
