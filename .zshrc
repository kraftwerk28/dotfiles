#!/bin/zsh

fpath+=("$HOME/.zfunc")

dot_config="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# zmodload zsh/zprof
# setopt xtrace

# Options
setopt auto_menu complete_in_word always_to_end promptsubst
setopt appendhistory auto_pushd pushd_ignore_dups pushd_minus auto_cd
setopt extended_history hist_expire_dups_first hist_ignore_dups
setopt hist_ignore_space hist_verify share_history nonomatch interactivecomments
setopt hist_ignore_dups hist_ignore_all_dups hist_find_no_dups
unsetopt prompt_sp

# Autoloads
autoload -U add-zsh-hook edit-command-line compinit

zle -N edit-command-line

requires () {
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

plug () {
	for c in {/usr/share/zsh/plugins,$dot_config/plugins}/$1/$1.plugin.zsh; do
		if [[ -f $c ]]; then
			source "$c"
			return
		fi
	done
	echo "Could not load plugin '$1'" >&2
}

zvm_config () {
	ZVM_TERM=xterm-256color
	ZVM_CURSOR_STYLE_ENABLED=true
	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
	# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	# ZVM_INSERT_MODE_CURSOR=$ZVM_NORMAL_MODE_CURSOR
	# ZVM_VISUAL_MODE_CURSOR=$ZVM_NORMAL_MODE_CURSOR
}

plug zsh-autosuggestions
# plug zsh-z
plug zsh-vi-mode
plug zsh-fzf-history-search

ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS='--reverse --height=10 --cycle'

# export BASE16_THEME="default-dark"
# export BASE16_THEME="gruvbox-dark-hard"
# export BASE16_THEME="woodland"
# export BASE16_THEME="eighties"

KEYTIMEOUT=true

compinit

zstyle ':completion:*' add-space false
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

# FIXME: setting `setopt BASH_REMATCH` breaks df<motion> in zsh-vi-mode
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

tabs -4

if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
	source "/etc/profile.d/vte.sh"
fi

source "$dot_config/alias.zsh"
source "$dot_config/completion_scripts.zsh"
source "$dot_config/dotfiles.zsh"
source "$dot_config/idle_notifier.zsh"
source "$dot_config/prompt.zsh"

WORDCHARS='-'

bindkeys () {
	source "$dot_config/bindkey.zsh"
}

if [[ -z $ZVM_INIT_DONE ]]; then
	bindkeys
else
	zvm_after_init_commands=(bindkeys)
fi

dump_cwd () {
	[[ $PWD != $HOME ]] && echo $PWD > /tmp/last_pwd
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

# Make `null` values bold red instead of dim dark in jq colored output
# https://github.com/stedolan/jq/issues/1972#issuecomment-721667377
export JQ_COLORS='0;31:0;39:0;39:0;39:0;32:1;39:1;39'

(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd)"

updatenvim () {
	pushd $HOME/projects/neovim/neovim
	git pull -r upstream HEAD
	(
		export CMAKE_BUILD_TYPE=RelWithDebInfo
		export CMAKE_INSTALL_PREFIX=/usr
		make
		sudo make install
	)
	popd
}

mkcd () {
	if [[ -z "$1" ]]; then
		echo "Usage: mkcd <dir>" 1>&2
		return 1
	fi
	mkdir -p "$1"
	cd "$1"
}

yt-dlp () {
	args=("$@")
	if (( $# == 0 )) && wl-paste -l | grep "text/plain" >/dev/null; then
		args+=("$(wl-paste)")
	fi
	/usr/bin/yt-dlp "${args[@]}"
}

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

bindkey -M viins -s '^K' '^ureset\n'

# It requires to be sourced at the end
# plug zsh-syntax-highlighting
