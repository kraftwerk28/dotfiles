export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="/usr/bin/nvim"
export PAGER="less -i"
export MANPAGER="nvim +Man!"

export PATH="$PATH:$HOME/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUSTC_WRAPPER=sccache

export JAVA_HOME="/usr/lib/jvm/default"

# android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# GO
export GOPATH="$HOME/projects/go"
export GO111MODULE="on"
export PATH="$PATH:$HOME/projects/go/bin"

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
export PATH="$PATH:$HOME/.nvm/versions/node/v16.11.1/bin"

# Haskell stuff
export PATH="$PATH:$HOME/.cabal/bin/"
export PATH="$PATH:$HOME/.ghcup/bin/"

export NVIM_LISTEN_PORT=6969
