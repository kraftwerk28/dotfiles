# NOTE: try to not use any command substitution here to keep shell start time as little as possible.
# Put everything else in ~/.zshrc / ~/.zprofile
#
# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

if which nvim &> /dev/null; then
	export EDITOR="nvim"
	export VISUAL="nvim"
	export MANPAGER="nvim +Man!"
fi

export PAGER="less -i"

if which alacritty &> /dev/null && [[ -z $TERM ]]; then
	export TERM="alacritty"
fi

export PATH="$HOME/.cargo/bin:$PATH"
export RUSTC_WRAPPER="sccache"

# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_AVD_HOME="$XDG_CONFIG_HOME/.android/avd"

# Golang
export GOPATH="$HOME/projects/go"
export PATH="$GOPATH/bin:$PATH"

# Python
export PYTHONPATH="$HOME/projects/python"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Lua
export PATH="$HOME/.luarocks/bin/:$PATH"

# Haskell
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"

export NVIM_LISTEN_PORT=6969

export CMAKE_EXPORT_COMPILE_COMMANDS=1
export CMAKE_GENERATOR="Ninja"

export QT_QPA_PLATFORMTHEME="qt5ct"

export SUDO_PROMPT=$'\a[sudo] password for %p: '

# Make `null` values bold red instead of dim dark in jq colored output
# https://github.com/stedolan/jq/issues/1972#issuecomment-721667377
export JQ_COLORS='0;31:0;39:0;39:0;39:0;32:1;39:1;39'

# export BAT_THEME="ansi"

export MPLBACKEND=GTK3Agg

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
