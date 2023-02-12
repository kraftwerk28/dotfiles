env_gen="/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator"
if [[ -x "$env_gen" ]]; then
	while read -r line; do
		eval "export $line"
	done < <("$env_gen")
fi

if (( $+commands[nvim] )); then
	export EDITOR="nvim"
	export VISUAL="nvim"
	export MANPAGER="nvim +Man!"
fi

export PAGER="less -i"

if (( $+commands[alacritty] )); then
	export TERM=alacritty
fi

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

export SUDO_PROMPT=$'\a[sudo] password for %p: '

# Make `null` values bold red instead of dim dark in jq colored output
# https://github.com/stedolan/jq/issues/1972#issuecomment-721667377
export JQ_COLORS='0;31:0;39:0;39:0;39:0;32:1;39:1;39'
