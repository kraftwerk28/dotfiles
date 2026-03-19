# The function is not used anymore
# git_info() {
# 	if [[ ! -d ".git" ]] || ! git rev-parse --git-dir &>/dev/null; then
# 		return
# 	fi
# 	result=" %B%F{blue}\ue0a0%b%F{yellow}$(git branch --show-current)"
# 	if git diff-index --quiet HEAD &>/dev/null; then
# 		result="${result}%B%F{green}✔"
# 	else
# 		result="${result}%B%F{red}✗"
# 	fi
# 	result="$result%b%f%k"
# 	echo $result
# }

REPORTTIME=2

autoload -Uz vcs_info

+vi-check-dirty() {
	if git diff-index --exit-code --quiet HEAD &>/dev/null; then
		hook_com[misc]="%B%F{green}✔"
	else
		hook_com[misc]="%B%F{red}✘"
	fi
}

zstyle ':vcs_info:git:*' formats ' %B%F{blue}%%F{magenta}%b%f%m%Q%%b'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git+set-message:*:*' hooks check-dirty
# zstyle ':vcs_info:git:*' unstagedstr '%B%F{red}✗'
# zstyle ':vcs_info:git:*' check-for-staged-changes true
# zstyle ':vcs_info:git:*' stagedstr '%B%F{red}✗'
# zstyle ':vcs_info:*' patch-format '#%p [%n|%c]'

# vimode_label() {
# 	case $ZVM_MODE in
# 		$ZVM_MODE_NORMAL) echo " %B%F{green}N";;
# 		$ZVM_MODE_INSERT) echo " %B%F{cyan}I";;
# 		$ZVM_MODE_VISUAL) echo " %B%F{yellow}V";;
# 		*)                echo " %B%F{cyan}I";;
# 	esac
# }

# vimode_rlabel() {
# 	w=$(( COLUMNS / 6 ))
# 	case $ZVM_MODE in
# 		$ZVM_MODE_NORMAL) echo "%F{green}NORMAL";;
# 		$ZVM_MODE_INSERT) echo "%F{blue}INSERT";;
# 		$ZVM_MODE_VISUAL) echo "%F{yellow}VISUAL";;
# 		*)                echo "";;
# 	esac
# }

set_prompt() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		local ver="${$(python -V)#* }"
		venv_info=" %B%F{yellow}🐍%f%b${ver}"
	fi
	vcs_info
}
PROMPT=$'%B%(4~|…/%2~|%~)%b${vcs_info_msg_0_}${venv_info} %B%(?.%F{green}.%F{red})$?%b%f\n$ '

add-zsh-hook precmd set_prompt

# zle-keymap-select zle-line-init() {
# 	precmd
# 	zle reset-prompt
# }
# zle -N zle-keymap-select zle-line-init

# filepath='%(4~|…/%2~|%~)%b%f'
# git_info='${vcs_info_msg_0_}%b%f'
# exit_status=' %B%(?.%F{green}.%F{red})$?%b%f'
# venv_info='${venv_info_msg}'
# PROMPT="${filepath}${git_info}${venv_info}${exit_status}\n"
# RPROMPT='%F{magenta}${exec_time_prompt}%b%f $(printf %-3d $?)'
# RPROMPT='%b%f $(printf %-3d $?)'

# add-zsh-hook precmd vcs_info
# add-zsh-hook precmd virtualenv_info
# add-zsh-hook precmd set_prompt

# _exec_time_preexec() {
# 	cmd_exec_time=$SECONDS
# }

# _exec_time_precmd() {
# 	if [[ -z $cmd_exec_time ]]; then
# 		return
# 	fi
# 	local seconds=$(( SECONDS - cmd_exec_time ))
# 	unset exec_time_prompt
# 	if (( seconds >= 3600 )); then
# 		exec_time_prompt="$((seconds / 3600))h"
# 		seconds=$((seconds % 3600))
# 	fi
# 	if ((seconds >= 60)); then
# 		exec_time_prompt="${exec_time_prompt}$((seconds / 60))m"
# 		seconds=$((seconds % 60))
# 	fi
# 	if ((seconds > 0)); then
# 		exec_time_prompt="${exec_time_prompt}${seconds}s"
# 	fi
# 	unset cmd_exec_time
# }
