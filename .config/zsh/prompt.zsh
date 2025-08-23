# The function is not used anymore

git_info() {
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

zstyle ':vcs_info:git:*' formats ' %B%F{blue}%%F{magenta}%b%f%m%Q%%b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git+set-message:*:*' hooks check-dirty
# zstyle ':vcs_info:git:*' unstagedstr '%B%F{red}✗'
# zstyle ':vcs_info:git:*' check-for-staged-changes true
# zstyle ':vcs_info:git:*' stagedstr '%B%F{red}✗'
# zstyle ':vcs_info:*' patch-format '#%p [%n|%c]'

+vi-check-dirty() {
	if git diff-index --exit-code --quiet HEAD &>/dev/null; then
		hook_com[misc]="%B%F{green}✔"
	else
		hook_com[misc]="%B%F{red}✘"
	fi
}

vimode_label() {
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL) echo " %B%F{green}N";;
		$ZVM_MODE_INSERT) echo " %B%F{cyan}I";;
		$ZVM_MODE_VISUAL) echo " %B%F{yellow}V";;
		*)                echo " %B%F{cyan}I";;
	esac
}

vimode_rlabel() {
	w=$(( COLUMNS / 6 ))
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL) echo "%F{green}NORMAL";;
		$ZVM_MODE_INSERT) echo "%F{blue}INSERT";;
		$ZVM_MODE_VISUAL) echo "%F{yellow}VISUAL";;
		*)                echo "";;
	esac
}

filepath='%(4~|…/%2~|%~)%b%f'
git_info='${vcs_info_msg_0_}%b%f'
exit_status='%(?:%B%F{green}:%B%F{red})$?%b%f'
PROMPT="$filepath$git_info $exit_status $ "
# RPROMPT='%F{magenta}${exec_time_prompt}%b%f $(printf %-3d $?)'
# RPROMPT='%b%f $(printf %-3d $?)'

add-zsh-hook precmd vcs_info

_exec_time_preexec() {
	cmd_exec_time=$SECONDS
}

_exec_time_precmd() {
	if [[ -z $cmd_exec_time ]]; then
		return
	fi
	local seconds=$(( SECONDS - cmd_exec_time ))
	unset exec_time_prompt
	if (( seconds >= 3600 )); then
		exec_time_prompt="$((seconds / 3600))h"
		seconds=$((seconds % 3600))
	fi
	if ((seconds >= 60)); then
		exec_time_prompt="${exec_time_prompt}$((seconds / 60))m"
		seconds=$((seconds % 60))
	fi
	if ((seconds > 0)); then
		exec_time_prompt="${exec_time_prompt}${seconds}s"
	fi
	unset cmd_exec_time
}

REPORTTIME=2
