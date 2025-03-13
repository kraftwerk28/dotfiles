# env_gen="/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator"
# if [[ -x "$env_gen" ]]; then
# 	while read -r line; do
# 		eval "export $line"
# 	done < <("$env_gen")
# fi

if [[ -d $HOME/.gem/ruby ]]; then
	ver=$(find ~/.gem/ruby/* -maxdepth 0 | sort -rV | head -n 1)
	export PATH="$PATH:${ver}/bin"
fi

# Run wayland compositor on tty1
if [[ "$(tty)" == "/dev/tty1" ]]; then
	# sway specific variables, don't put these in .zshenv
	export TERM="foot"
	export GTK_USE_PORTAL=1
	export QT_QPA_PLATFORMTHEME="qt6ct"

	# See https://wiki.archlinux.org/title/GTK#GTK_4_applications_are_slow
	export GSK_RENDERER=gl

	# See https://github.com/swaywm/sway/wiki#xdg_current_desktop-environment-variable-is-not-being-set
	export XDG_CURRENT_DESKTOP="sway:wlroots"

	export _JAVA_AWT_WM_NONREPARENTING=1
	# export WLR_DRM_NO_ATOMIC=1

	# Setup logging
	logfile="$XDG_STATE_HOME/sway/$(date -Is).log"
	mkdir -p "$(dirname $logfile)"
	# Remove logs older than 14 days
	find "$(dirname $logfile)" -maxdepth 1 -type f -mtime +14 -name '*.log' -execdir rm -v '{}' \;

	exec sway --unsupported-gpu
	# exec sway --unsupported-gpu --config=$conffile &> "$logfile"
	# exec sway --verbose --debug --unsupported-gpu \
	# 	--config ~/projects/wayland/sway/myconfig \
	# 	&> "${sway_logdir}/sway-debug.log"
fi

# Run xorg DE / WM on tty2
if [[ "$(tty)" == "/dev/tty2" ]]; then
	export XDG_CURRENT_DESKTOP="i3"
	exec startx
fi
