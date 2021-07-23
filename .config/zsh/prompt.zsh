git_info () {
	if [[ ! -d ".git" ]] || ! git rev-parse --git-dir 2>&1 > /dev/null; then
		return
	fi
	result=" %B%F{blue}\ue0a0%b%F{yellow}$(git branch --show-current)"
	if command git diff-index --quiet HEAD 2>&1 > /dev/null; then
		result="${result}%B%F{green}✔"
	else
		result="${result}%B%F{red}✗"
	fi
	result="$result%b%f%k"
	echo $result
}

vimode () {
	if [[ "$KEYMAP" == "vicmd" ]] || [[ "$1" == "block" ]]; then
		# NORMAL
		if [[ "$CHANGE_CURSOR_SHAPE" == 1 ]]; then
			echo -ne "\e[1 q";
		fi
		if [[ "$SHOW_VIMODE" == 1 ]]; then
			echo " %B%F{green}N"
		fi
	elif [[ "$KEYMAP" =~ ^(main|viins|)$ ]] || [[ "$1" == "beam" ]]; then
		# INSERT
		if [[ "$CHANGE_CURSOR_SHAPE" == 1 ]]; then
			echo -ne "\e[5 q"
		fi
		if [[ "$SHOW_VIMODE" == 1 ]]; then
			echo " %B%F{cyan}I"
		fi
	elif [[ "$KEYMAP" == "visual" ]]; then
		# VISUAL
		if [[ "$CHANGE_CURSOR_SHAPE" == 1 ]]; then
			echo -ne "\e[4 q"
		fi
		if [[ "$SHOW_VIMODE" == 1 ]]; then
			echo " %B%F{orange}V"
		fi
	fi
}

refresh_prompt () {
	FILEPATH="%F{#ffa500}%(4~|…/%2~|%~)"
	PROMPT_STATUS=" %(?:%B%F{green}\$:%B%F{red}\$)"
	CL_RESET="%b%f%k"
	PROMPT="${FILEPATH}$(git_info)$(vimode)${PROMPT_STATUS}${CL_RESET} "
	RPROMPT="%F{green}[$(date +%H:%M:%S)]$CL_RESET"
}

zle-keymap-select () {
	refresh_prompt "$1"
	zle reset-prompt
}

zle -N zle-keymap-select
zle -N edit-command-line
precmd_functions+=(refresh_prompt)
