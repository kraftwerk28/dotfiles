env_gen="/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator"
if [[ -x "$env_gen" ]]; then
	while read -r line; do
		eval "export $line"
	done < <("$env_gen")
fi

export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="/usr/bin/nvim"
export PAGER="less -i"
export MANPAGER="nvim +Man!"
export TERMINAL="$(which foot)"

export PATH="$HOME/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUSTC_WRAPPER="sccache"

export JAVA_HOME="/usr/lib/jvm/default"

# android
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# GO
export GOPATH="$HOME/projects/go"
export PATH="$PATH:$GOPATH/bin"

# ruby
if [[ -d ~/.gem/ruby ]]; then
	ver=$(find ~/.gem/ruby/* -maxdepth 0 | sort -rV | head -n 1)
	export PATH="$PATH:${ver}/bin"
fi

# python
export PYTHONPATH="$HOME/projects/python"

# Lua
export PATH="$PATH:$HOME/.luarocks/bin/"
# luavers=(5.1 5.4)
# export LUA_PATH="$HOME/projects/lua/?.lua;"
# for ver in ${luavers[@]}; do
#   export LUA_PATH="$LUA_PATH$HOME/.luarocks/share/lua/$ver/?.lua;"
#   export LUA_CPATH="$LUA_CPATH$HOME/.luarocks/lib/lua/$ver/?.so;"
# done
# export LUA_PATH="$LUA_PATH;"
# export LUA_CPATH="$LUA_CPATH;"

# npm global modules
export NODE_PATH="$HOME/.npm-global/lib/node_modules"
# export PATH="$PATH:$HOME/.npm-global/bin"
export NVS_HOME="$HOME/.nvs"

# NVM_VERSIONS="$HOME/.nvm/versions/node"
# LATEST_NODE_VER="$(/bin/ls -v "$NVM_VERSIONS" 2>/dev/null | tail -1)"
# if [[ -n $LATEST_NODE_VER ]]; then
# 	export PATH="${NVM_VERSIONS}/${LATEST_NODE_VER}/bin:${PATH}"
# fi

# Haskell stuff
export PATH="$PATH:$HOME/.cabal/bin/"
export PATH="$PATH:$HOME/.ghcup/bin/"

export NVIM_LISTEN_PORT=6969

export CMAKE_EXPORT_COMPILE_COMMANDS=1

# Start sway automatically on tty1
if [[ -z $DISPLAY && $TTY = "/dev/tty1" ]]; then
	export GTK_USE_PORTAL=1
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM=wayland
	export QT_QPA_PLATFORMTHEME=qt5ct
	export XDG_CURRENT_DESKTOP=sway
	export _JAVA_AWT_WM_NONREPARENTING=1
	# export WLR_RENDERER=vulkan

	sway_logdir="${HOME}/sway.d"
	mkdir -p "$sway_logdir"
	logfile="${sway_logdir}/sway-$(date -Is).log"

	exec sway --unsupported-gpu &> "$logfile"
	# exec sway --verbose --debug --unsupported-gpu \
	# 	--config ~/projects/wayland/sway/myconfig \
	# 	&> "${sway_logdir}/sway-debug.log"
fi
