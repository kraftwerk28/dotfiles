fpath=(~/.zfunc $fpath)

plug () {
	local plugfile=/usr/share/zsh/plugins/$1
	[[ -f $plugfile ]] && source $plugfile
}

plug zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
plug zsh-z/zsh-z.plugin.zsh
plug zsh-extract/extract.plugin.zsh
plug zsh-vi-mode/zsh-vi-mode.plugin.zsh

# export BASE16_THEME="default-dark"
# export BASE16_THEME="gruvbox-dark-hard"
# export BASE16_THEME="woodland"
export BASE16_THEME="eighties"

NOTIFY_COMMAND_COMPLETED_TRESHOLD=10

ZVM_CURSOR_STYLE_ENABLED=true
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# Change cursor shape depending on vi mode
# CHANGE_CURSOR_SHAPE=false
# Show a character depending on vi mode
# SHOW_VIMODE=true
KEYTIMEOUT=true

autoload -U select-word-style
select-word-style bash
setopt appendhistory autocd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

tabs -4

if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
	source /etc/profile.d/vte.sh
fi

for cfg in ~/.config/zsh/*.zsh; do
	source $cfg
done

bindkey -v
bindkey "^[OA" up-line-or-history
bindkey "^[OB" down-line-or-history
bindkey "^ " autosuggest-accept
bindkey "^[[Z" reverse-menu-complete
bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^P" up-history
bindkey -M viins "^N" down-history
bindkey -M viins "^H" backward-kill-word
bindkey -s "^[l" "ls\n"
bindkey -M viins "^I" complete-word

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh" --no-use
fi

dump_cwd () {
	dir=$(pwd)
	if [[ $dir != $HOME ]]; then
		echo $dir > /tmp/last_pwd
	fi
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
