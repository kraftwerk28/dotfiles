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

vimode () {
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL) echo " %B%F{green}N";;
		$ZVM_MODE_INSERT) echo " %B%F{cyan}I";;
		$ZVM_MODE_VISUAL) echo " %B%F{yellow}V";;
		*) echo " %B%F{cyan}I";;
	esac
}

refresh_prompt () {
	FILEPATH="%F{#ffa500}%(4~|…/%2~|%~)"
	PROMPT_STATUS=" %(?:%B%F{green}\$:%B%F{red}\$)"
	CL_RESET="%b%f%k"
	PROMPT="${FILEPATH}$(git_info)$(vimode)${PROMPT_STATUS}${CL_RESET} "
	# RPROMPT="%F{green}[$(date +%H:%M:%S)]$CL_RESET"
}

zle-keymap-select () {
	refresh_prompt "$1"
	zle reset-prompt
}

zle -N zle-keymap-select
zle -N edit-command-line
zvm_after_select_vi_mode_commands+=(refresh_prompt)
