export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nvim

# custom
export PATH="$PATH:$HOME/scripts"

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

# ruby
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

# npm global modules
export NODE_PATH="$HOME/.npm-global/bin"
export PATH="$PATH:$NODE_PATH"
export NVS_HOME="$HOME/.nvs"
