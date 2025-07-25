# fpath+=("$HOME/.zfunc")

dot_config="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Options
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PROMPTSUBST
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt AUTO_CD
setopt NONOMATCH
setopt INTERACTIVECOMMENTS
setopt MAGIC_EQUAL_SUBST

setopt APPENDHISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

unsetopt PROMPT_SP

autoload -U add-zsh-hook

# Completion
autoload -U compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

zstyle ':completion:*' add-space false
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"
zstyle ':completion:*' rehash true

# Alias
if which nvim &> /dev/null; then
	alias vim="nvim"
	alias vi="nvim"
	alias v="nvim"
	alias im="nvim"
	alias vin="nvim"
fi

if which lsd &> /dev/null; then
	alias ls="lsd -F"
	alias la="lsd -Fah"
	alias ll="lsd -Flh"
	alias l="lsd -Flah"
fi

alias less="less -i"

if which bat &> /dev/null; then
	# alias cat="bat -p --color never --paging never"
	alias cat="bat"
fi

if which git &> /dev/null; then
	alias gst="git status"
	alias gco="git checkout"
	alias gcb="git checkout -b"
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias ssh='TERM=xterm-256color ssh'

alias dotfiles="git --git-dir=$HOME/projects/dotfiles --work-tree=$HOME"

alias pino-pretty="pino-pretty -t SYS:isoDateTime -i hostname,pid"

dotfilesupd() (
	dotfiles add -u
	dotfiles commit -m "Update dotfiles"
	dotfiles push origin HEAD
)

source "$dot_config/idle_notifier.zsh"
source "$dot_config/prompt.zsh"

# Simple plugin management
plug() {
	local plug=$1
	local plugdirs=("${XDG_CONFIG_HOME}/zsh/plugins" "/usr/share/zsh/plugins")
	local plugsrc="$plugdir/$plug/$plug.plugin.zsh"
	for dir in $plugdirs; do
		local src=($dir/$plug/*.plugin.zsh(N[1]))
		if [[ -f "$src" ]]; then
			source "$src"
			return
		fi
	done
	echo "Plugin $plug not found. Please install it"
}

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
plug zsh-autosuggestions

# zvm_config() {
# 	# ZVM_TERM=xterm-256color
# 	ZVM_CURSOR_STYLE_ENABLED=true
# 	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# 	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
# 	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# }
# plug zsh-vi-mode

# NOTE: sourced AFTER zsh-vi-mode
source "$dot_config/bindkey.zsh"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

tabs -4

WORDCHARS='-'

# Dump working directory for using in sway keybindings, i.e. $mod+Shift+Enter
dump_cwd() {
	if [[ $PWD != $HOME ]]; then
		echo "$PWD" > /tmp/last-cwd
	fi
}
add-zsh-hook precmd dump_cwd

# cd into $XDG_CONFIG_HOME/$1 directory
c() {
	local root=${XDG_CONFIG_HOME:-$HOME/.config}
	local dname="$root/$1"
	if [[ -d "$dname" ]]; then
		cd "$dname"
	fi
}

# Python venv
manage_venv() {
	local script="$PWD/.venv/bin/activate"
	if [[ -f $script ]]; then
		source $script
	elif which deactivate &> /dev/null; then
		deactivate
	fi
}
add-zsh-hook chpwd manage_venv
manage_venv

# Terminal title
set_title() {
	printf '\e]2;%s\e\\' $1
}
set_window_title() {
	set_title "$(basename $SHELL) (${PWD/$HOME/"~"}) $1"
}
reset_window_title() {
	set_title "$(basename $SHELL) (${PWD/$HOME/~})"
}
add-zsh-hook precmd reset_window_title
add-zsh-hook preexec set_window_title

# Foot terminal fix
foot_quirk() {
	# Disable reverse wrapping mode in foot terminal
	echo -n "\e[?45l"
}
add-zsh-hook precmd foot_quirk

mkcd() {
	if [[ -z "$1" ]]; then
		echo "Usage: mkcd <dir>" 1>&2
		return 1
	fi
	mkdir -p "$1"
	cd "$1"
}

ytd() {
	args=("$@")
	if [[ $# -eq 0 ]] && wl-paste -l | grep "text/plain" >/dev/null; then
		args+=("$(wl-paste)")
	fi
	yt-dlp "${args[@]}"
}

if which zoxide &> /dev/null; then
	eval "$(zoxide init zsh)"
fi

# nvm_init=/usr/share/nvm/init-nvm.sh
# if [[ -f $nvm_init ]]; then
# 	source $nvm_init
# fi

if which fnm &> /dev/null; then
	eval "$(fnm env --use-on-cd --shell=zsh --resolve-engines=false)"
fi

if which pyenv &> /dev/null; then
	export PYENV_ROOT=$HOME/.pyenv
	if [[ -d $PYENV_ROOT/bin ]]; then
		export PATH=$PYENV_ROOT/bin:$PATH
	fi
	eval "$(pyenv init -)"
fi

if which paru &> /dev/null; then
	alias yay=paru
fi

if which fzf &> /dev/null; then
	FZF_CTRL_R_OPTS="--reverse --cycle"
	source <(fzf --zsh)
fi

# FIXME: for some reason, this doesn't work
# if which fnm &> /dev/null; then
# 	eval "$(fnm env --use-on-cd)"
# fi

get_idf() {
	source $HOME/projects/esp/esp-idf/export.sh
	# sudo sysctl -w dev.tty.legacy_tiocsti=1
}

imv_dir() {
	if (( $# > 1 )); then
		exit 1
	fi
	dir=$(dirname $1)
	imv -n "$1" $dir/*.{jpg,jpeg,png}
}

reboot-win10() {
	systemctl reboot --boot-loader-entry=windows10.conf
}

export QSYS_ROOTDIR="/home/kraftwerk28/.cache/paru/clone/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/24.1/quartus/sopc_builder/bin"
export LS_COLORS="$(vivid generate gruvbox-light)"
