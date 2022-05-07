#!/bin/zsh

fpath+=("$HOME/.zfunc")

# zmodload zsh/zprof
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
autoload -U add-zsh-hook edit-command-line vcs_info compinit
# export WORDCHARS='-'

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
	for c in {/usr/share/zsh/plugins,$HOME/.config/zsh/plugins}/$1/$1.plugin.zsh; do
		if [[ -f $c ]]; then
			source "$c"
			return
		fi
	done
	echo "Plugin $1 not found" >&2
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
plug zsh-fzf-history-search

ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS='--reverse --height=10 --cycle'

# export BASE16_THEME="default-dark"
# export BASE16_THEME="gruvbox-dark-hard"
# export BASE16_THEME="woodland"
# export BASE16_THEME="eighties"

KEYTIMEOUT=true

compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' list-colors ''

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

bindkeys () {
	# bindkey -v "^[[A" history-search-backward
	# bindkey -v "^[[B" history-search-forward
	# bindkey -v "^R" history-incremental-search-backward
	# bindkey -v "^[r" history-incremental-search-forward
	bindkey "^R" fzf_history_search
	bindkey -v "^ " autosuggest-accept # Control+Space
	bindkey -v "^[[Z" reverse-menu-complete # Shift+Tab
	bindkey -v "^H" vi-backward-kill-word # Shift+Backspace
	bindkey -v "^W" vi-backward-kill-word
	bindkey -v -s "^[l" "ls\n"
	bindkey -v "^I" complete-word
}

zvm_after_init_commands=(bindkeys)

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
