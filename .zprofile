if [[ "$(tty)" == /dev/tty1 ]]; then
	# sway specific variables, don't put these in .zshenv
	export TERM=foot
	export GTK_USE_PORTAL=1
	export QT_QPA_PLATFORMTHEME=qt6ct
	# See https://wiki.archlinux.org/title/GTK#GTK_4_applications_are_slow
	export GSK_RENDERER=gl
	# See https://github.com/swaywm/sway/wiki#xdg_current_desktop-environment-variable-is-not-being-set
	export XDG_CURRENT_DESKTOP=sway:wlroots
	export _JAVA_AWT_WM_NONREPARENTING=1
	# export WLR_DRM_NO_ATOMIC=1

	# Setup logging
	logfile="$XDG_STATE_HOME/sway/$(date -Is).log"
	mkdir -pv "$(dirname $logfile)"
	# Remove old logs
	find "$(dirname $logfile)" -maxdepth 1 -type f -mtime +14 -name '*.log' -execdir rm -v '{}' \;

	# exec sway --unsupported-gpu
	exec sway --unsupported-gpu &> "$logfile"
fi

if [[ "$(tty)" == /dev/tty2 ]]; then
	export TERM=alacritty
	export XDG_CURRENT_DESKTOP=i3
	exec startx
fi
