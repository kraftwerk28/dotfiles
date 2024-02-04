env_gen="/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator"
if [[ -x "$env_gen" ]]; then
	while read -r line; do
		eval "export $line"
	done < <("$env_gen")
fi

if [[ -d ~/.gem/ruby ]]; then
	ver=$(find ~/.gem/ruby/* -maxdepth 0 | sort -rV | head -n 1)
	export PATH="$PATH:${ver}/bin"
fi

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

	# Setup logging
	logfile="$XDG_STATE_HOME/sway/$(date -Is).log"
	mkdir -p "$(dirname $logfile)"
	# Remove logs older than 14 days
	find "$(dirname $logfile)" -maxdepth 1 -type f -mtime +14 -name '*.log' -execdir rm -v '{}' \;
	conffile="$XDG_CONFIG_HOME/sway/config"

	exec sway --unsupported-gpu --config=$conffile &> "$logfile"

	# exec sway --verbose --debug --unsupported-gpu \
	# 	--config ~/projects/wayland/sway/myconfig \
	# 	&> "${sway_logdir}/sway-debug.log"
fi
