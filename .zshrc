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

# Autoloads
autoload -U add-zsh-hook

requires() {
	local banner="$(basename "$0"): please install:"
	local failed=false
	for cmd in "$@"; do
		if ! command -v $cmd 2>&1 > /dev/null; then
			banner="$banner $cmd"
			failed=true
		fi
	done
	if [[ $failed == true && $REQUIRES_VERBOSE == 1 ]]; then
		echo "$banner" >&2
		return 1
	fi
}

# zvm_config() {
# 	ZVM_TERM=xterm-256color
# 	ZVM_CURSOR_STYLE_ENABLED=true
# 	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# 	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
# 	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_INSERT_MODE_CURSOR=$ZVM_NORMAL_MODE_CURSOR
# 	# ZVM_VISUAL_MODE_CURSOR=$ZVM_NORMAL_MODE_CURSOR
# }
# source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

source "$dot_config/completion.zsh"
source "$dot_config/alias.zsh"
source "$dot_config/dotfiles.zsh"
source "$dot_config/idle_notifier.zsh"
source "$dot_config/prompt.zsh"
source "$dot_config/venv.zsh"

plug() {
	local files=($dot_config/plugins/$1/*.plugin.zsh(N))
	if (( "${#files}" == 0 )); then
		echo "Plugin $1 not found, please install it." >&2
		return
	fi
	for file in "${files[@]}"; do
		source "$file"
	done
}

plug zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

plug zsh-fzf-history-search
ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS="--reverse --height=10 --cycle"

ZVM_INIT_MODE=sourcing
ZVM_TERM=xterm-256color # TERM=foot lacks cursor shaping
plug zsh-vi-mode

ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK

ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# NOTE: sourced AFTER zsh-vi-mode
source "$dot_config/bindkey.zsh"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

tabs -4

WORDCHARS='-'

dump_cwd () {
	if [[ $PWD == $HOME ]]; then return; fi
	echo $PWD > /tmp/last_pwd
}
add-zsh-hook precmd dump_cwd

# cd into $XDG_CONFIG_HOME/$1 directory
c() {
	local root=${XDG_CONFIG_HOME:-~/.config}
	local dname="$root/$1"
	if [[ ! -d "$dname" ]]; then
		return
	fi
	cd "$dname"
}

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

foot_quirk() {
	# Disable reverse wrapping mode in foot terminal
	echo -n "\e[?45l"
}
add-zsh-hook precmd foot_quirk

noprompt () {
	add-zsh-hook -d precmd refresh_prompt
	PS1="$ "
}

mkcd () {
	if [[ -z "$1" ]]; then
		echo "Usage: mkcd <dir>" 1>&2
		return 1
	fi
	mkdir -p "$1"
	cd "$1"
}

ytd () {
	args=("$@")
	if (( $# == 0 )) && wl-paste -l | grep "text/plain" >/dev/null; then
		args+=("$(wl-paste)")
	fi
	/usr/bin/yt-dlp "${args[@]}"
}

if which zoxide &> /dev/null; then
	eval "$(zoxide init zsh)"
fi

if which fnm &> /dev/null; then
	eval "$(fnm env --use-on-cd)"
fi

# FIXME: for some reason, this doesn't work
# (( $+commands[fnm] )) && eval "$(fnm env --use-on-cd)"

get_idf () {
	source /opt/esp-idf/export.sh
	# sudo sysctl -w dev.tty.legacy_tiocsti=1
}

# It is required to source it at the end
# plug zsh-syntax-highlighting
