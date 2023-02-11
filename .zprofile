if [[ -z $DISPLAY && $TTY = "/dev/tty1" ]]; then
	# Wayland-specific variables
	export TERM="foot"
	export GTK_USE_PORTAL=1
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
	export QT_QPA_PLATFORMTHEME="qt5ct"
	export XDG_CURRENT_DESKTOP="sway"
	export _JAVA_AWT_WM_NONREPARENTING=1
	# export WLR_RENDERER=vulkan
	export WLR_DRM_NO_ATOMIC=1

	sway_logdir="${HOME}/sway.d"
	mkdir -p "$sway_logdir"
	logfile="${sway_logdir}/sway-$(date -Is).log"

	# Remove logs older than 7 days
	find "$sway_logdir" -type f -mtime +7 -name '*.log' -execdir rm '{}' \;

	exec sway --unsupported-gpu &> "$logfile"
	# exec sway --verbose --debug --unsupported-gpu \
	# 	--config ~/projects/wayland/sway/myconfig \
	# 	&> "${sway_logdir}/sway-debug.log"
fi
