#!/bin/zsh

fpath+=("$HOME/.zfunc")

requires () {
	local banner="$(basename "$0"): please install:"
	local failed=false
	for cmd in "$@"; do
		if ! command -v $cmd 2>&1 > /dev/null; then
			banner="$banner $cmd"
			failed=true
		fi
	done
	if $failed; then
		echo "$banner" 1>&2
		return 1
	fi
}

plug () {
	local plugfile="/usr/share/zsh/plugins/${1}/${1}.plugin.zsh"
	if [[ -f $plugfile ]]; then
		source "$plugfile"
	else
		echo "Plugin $1 not found" 1>&2
	fi
}

zvm_config () {
	ZVM_CURSOR_STYLE_ENABLED=true
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

plug zsh-autosuggestions
plug zsh-z
plug zsh-vi-mode

# export BASE16_THEME="default-dark"
# export BASE16_THEME="gruvbox-dark-hard"
# export BASE16_THEME="woodland"
export BASE16_THEME="eighties"

NOTIFY_COMMAND_COMPLETED_TRESHOLD=10

# Change cursor shape depending on vi mode
# CHANGE_CURSOR_SHAPE=false
# Show a character depending on vi mode
# SHOW_VIMODE=true
KEYTIMEOUT=true

autoload -U select-word-style
select-word-style bash
setopt \
	appendhistory autocd auto_pushd pushd_ignore_dups pushdminus \
	extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space \
	hist_verify share_history nonomatch
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

for cfg in ~/.config/zsh/*.zsh; do
	source "$cfg"
done

# bindkey -v
bindkey -r "^[OA"
bindkey -r "^[OB"
bindkey -M viins "^[[A" history-search-backward
bindkey -M viins "^[[B" history-search-forward
# bindkey "^[OA" up-line-or-history
# bindkey "^[OB" down-line-or-history
bindkey "^ " autosuggest-accept # Control+Space
bindkey "^[[Z" reverse-menu-complete # Shift+Tab
# bindkey -M viins "^?" backward-delete-char
# bindkey -M viins "^W" backward-kill-word
# bindkey -M viins "^P" up-history
# bindkey -M viins "^N" down-history
bindkey -M viins "^H" backward-kill-word # Shift+Backspace
bindkey -s "^[l" "ls\n"
bindkey -M viins "^I" complete-word

if [[ -d "/usr/share/nvm" ]]; then
	nvm() {
		echo "Warming up nvm..."
		unset -f nvm
		[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"
		source /usr/share/nvm/nvm.sh
		source /usr/share/nvm/install-nvm-exec
		if (( $# > 0 )); then
			nvm $@
		fi
	}
	nvm_on_change_working_dir() {
		if [[ -f .nvmrc ]] && type nvm > /dev/null 2>&1 && nvm
	}
	add-zsh-hook chpwd nvm_on_change_working_dir
fi

dump_cwd () {
	dir=$(pwd)
	if [[ $dir != "$HOME" ]]; then
		echo $dir > /tmp/last_pwd
	fi
}

c () {
	local dname="$HOME/.config/$1"
	if [[ ! -d "$dname" ]]; then
		return
	fi
	cd "$dname"
}

set_window_title () {
	echo -n -e "\e]0;$(basename $SHELL) (${PWD/$HOME/"~"})\007"
}

add-zsh-hook precmd dump_cwd
add-zsh-hook precmd set_window_title

noprompt () {
	add-zsh-hook -d precmd refresh_prompt
	PS1="$ "
}
