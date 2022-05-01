#!/bin/zsh

fpath+=("$HOME/.zfunc")

# setopt xtrace

# Disable reverse wrapping mode in foot terminal
echo -n $'\e[?45l'

# Options
setopt auto_menu complete_in_word always_to_end promptsubst
setopt appendhistory autocd auto_pushd pushd_ignore_dups pushdminus
setopt extended_history hist_expire_dups_first hist_ignore_dups
setopt hist_ignore_space hist_verify share_history nonomatch interactivecomments
unsetopt PROMPT_SP

# Autoloads
autoload -U select-word-style add-zsh-hook edit-command-line vcs_info compinit

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
	local plugfile="/usr/share/zsh/plugins/${1}/${1}.plugin.zsh"
	if [[ -f $plugfile ]]; then
		source "$plugfile"
	else
		echo "Plugin $1 not found" 1>&2
	fi
}

zvm_config () {
	ZVM_CURSOR_STYLE_ENABLED=true
	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
	# Disables cursor styles
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
}

plug zsh-autosuggestions
plug zsh-z
plug zsh-vi-mode

# export BASE16_THEME="default-dark"
# export BASE16_THEME="gruvbox-dark-hard"
# export BASE16_THEME="woodland"
# export BASE16_THEME="eighties"

KEYTIMEOUT=true

select-word-style bash

compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

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

NO_THEME=1
for cfg in ~/.config/zsh/*.zsh; do
	if [[ $cfg =~ theme\.zsh$ && -n $NO_THEME ]]; then
		continue
	fi
	source "$cfg"
done

# NB: Some of these are handled by zsh-vi-mode.
# bindkey -v
bindkey -r "^[OA"
bindkey -r "^[OB"
bindkey -M viins "^[[A" history-search-backward
bindkey -M viins "^[[B" history-search-forward
bindkey -M viins "^R" history-incremental-search-backward
bindkey -M viins "^[r" history-incremental-search-forward

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
bindkey -M viins "^W" backward-delete-word

dump_cwd () {
	if [[ $PWD != $HOME ]]; then
		echo $PWD > /tmp/last_pwd
	fi
}

c () {
	local dname="$HOME/.config/$1"
	if [[ ! -d "$dname" ]]; then
		return
	fi
	cd "$dname"
}

set_window_title() {
	# TODO: escape the title
	local title="$(basename $SHELL) (${PWD/$HOME/"~"}) $1"
	echo -ne "\e]2;${title}\e\\"
}

reset_window_title() {
	# TODO: escape the title
	local title="$(basename $SHELL) (${PWD/$HOME/~})"
	echo -ne "\e]2;${title}\e\\"
}

add-zsh-hook precmd dump_cwd
add-zsh-hook precmd reset_window_title
add-zsh-hook preexec set_window_title

noprompt () {
	add-zsh-hook -d precmd refresh_prompt
	PS1="$ "
}

# Make `null` values bold red instead of dim dark in jq colored output
# https://github.com/stedolan/jq/issues/1972#issuecomment-721667377
export JQ_COLORS='0;31:0;39:0;39:0;39:0;32:1;39:1;39'

eval "$(fnm env --use-on-cd)"

# It requires to be sourced at the end
# plug zsh-syntax-highlighting
