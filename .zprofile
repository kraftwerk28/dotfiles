env_gen="/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator"
if [[ -x "$env_gen" ]]; then
	while read -r line; do
		eval "export $line"
	done < <("$env_gen")
fi

export EDITOR="/usr/bin/nvim"
export PAGER="less -i"
export MANPAGER="nvim +Man!"
export TERM="alacritty"

export PATH="$HOME/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"
export RUSTC_WRAPPER="sccache"

export JAVA_HOME="/usr/lib/jvm/default"

export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export GOPATH="$HOME/projects/go"
export PATH="$PATH:$GOPATH/bin"

if [[ -d ~/.gem/ruby ]]; then
	ver=$(find ~/.gem/ruby/* -maxdepth 0 | sort -rV | head -n 1)
	export PATH="$PATH:${ver}/bin"
fi

export PYTHONPATH="$HOME/projects/python"

export PATH="$PATH:$HOME/.luarocks/bin/"
# luavers=(5.1 5.4)
# export LUA_PATH="$HOME/projects/lua/?.lua;"
# for ver in ${luavers[@]}; do
#   export LUA_PATH="$LUA_PATH$HOME/.luarocks/share/lua/$ver/?.lua;"
#   export LUA_CPATH="$LUA_CPATH$HOME/.luarocks/lib/lua/$ver/?.so;"
# done
# export LUA_PATH="$LUA_PATH;"
# export LUA_CPATH="$LUA_CPATH;"

export PATH="$PATH:$HOME/.cabal/bin/"
export PATH="$PATH:$HOME/.ghcup/bin/"

export NVIM_LISTEN_PORT=6969

export CMAKE_EXPORT_COMPILE_COMMANDS=1

export QT_QPA_PLATFORMTHEME="qt5ct"

if [[ -z $DISPLAY && $TTY = "/dev/tty1" ]]; then
	export TERM="foot"
	export GTK_USE_PORTAL=1
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
	export QT_QPA_PLATFORMTHEME="qt5ct"
	export XDG_CURRENT_DESKTOP="sway"
	export _JAVA_AWT_WM_NONREPARENTING=1
	# export WLR_RENDERER=vulkan

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
