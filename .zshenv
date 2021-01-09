export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="/usr/bin/nvim"
export PAGER="less -i"

# custom
export PATH="$PATH:$HOME/.scripts"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# GO
export GOPATH="$HOME/projects/go"
export PATH="$PATH:$HOME/projects/go/bin"

# ruby
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

# python
export PYTHONPATH="$HOME/projects/python"

# Lua
export PATH="$PATH:$HOME/.luarocks/bin/"
export LUA_PATH="$HOME/projects/lua/?.lua;;"

# npm global modules
export NODE_PATH="$HOME/.npm-global/lib/node_modules/"
export PATH="$PATH:$HOME/.npm-global/bin/"
export NVS_HOME="$HOME/.nvs"

# Haskell stuff
export PATH="$PATH:$HOME/.cabal/bin/"
export PATH="$PATH:$HOME/.ghcup/bin/"

# Java MPI
export MPJ_HOME="$HOME/projects/mpj-v0_44/"
