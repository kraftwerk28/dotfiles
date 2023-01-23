# The function is not used anymore

git_info () {
	if [[ ! -d ".git" ]] || ! git rev-parse --git-dir &>/dev/null; then
		return
	fi
	result=" %B%F{blue}\ue0a0%b%F{yellow}$(git branch --show-current)"
	if git diff-index --quiet HEAD &>/dev/null; then
		result="${result}%B%F{green}✔"
	else
		result="${result}%B%F{red}✗"
	fi
	result="$result%b%f%k"
	echo $result
}

autoload -Uz vcs_info 

zstyle ':vcs_info:git:*' formats ' %B%F{blue}%%b%F{yellow}%b%f%m%Q%%b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git+set-message:*:*' hooks check-dirty
# zstyle ':vcs_info:git:*' unstagedstr '%B%F{red}✗'
# zstyle ':vcs_info:git:*' check-for-staged-changes true
# zstyle ':vcs_info:git:*' stagedstr '%B%F{red}✗'
# zstyle ':vcs_info:*' patch-format '#%p [%n|%c]'

+vi-check-dirty () {
	if git diff-index --exit-code --quiet HEAD &>/dev/null; then
		hook_com[misc]="%B%F{green}✔"
	else
		hook_com[misc]="%B%F{red}✘"
	fi
}

vimode_label () {
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL) echo " %B%F{green}N";;
		$ZVM_MODE_INSERT) echo " %B%F{cyan}I";;
		$ZVM_MODE_VISUAL) echo " %B%F{yellow}V";;
		*)                echo " %B%F{cyan}I";;
	esac
}

vimode_rlabel () {
	w=$(( COLUMNS / 6 ))
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL) echo "%F{green}NORMAL";;
		$ZVM_MODE_INSERT) echo "%F{blue}INSERT";;
		$ZVM_MODE_VISUAL) echo "%F{yellow}VISUAL";;
		*)                echo "";;
	esac
}

filepath='%F{#ffa500}%(4~|…/%2~|%~)'
exit_status=' %(?:%B%F{green}$:%B%F{red}$)%b%f'
PROMPT="$filepath"'${vcs_info_msg_0_}'"$exit_status "
RPROMPT='%F{magenta}${CMD_ELAPSED_TIME}%b%f'

add-zsh-hook precmd vcs_info

set_elapsed_time () {
	if [[ -z $CMD_EXEC_TIME ]]; then
		return
	fi
	CMD_ELAPSED_TIME="$(TZ=GMT+0 date -d "@$CMD_EXEC_TIME" +'%Hh %Mm %Ss' | sed 's#00\S\s*##g')"
}

add-zsh-hook precmd set_elapsed_time
