git_info () {
	if [[ ! -d ".git" ]] || ! git rev-parse --git-dir 2>&1 > /dev/null; then
		return
	fi
	result=" %B%F{blue}\ue0a0%b%F{yellow}$(git branch --show-current)"
	if command git diff-index --quiet HEAD > /dev/null 2>&1 ; then
		result="${result}%B%F{green}✔"
	else
		result="${result}%B%F{red}✗"
	fi
	result="$result%b%f%k"
	echo $result
}

# vimode () {
# 	if [[ "$KEYMAP" == "vicmd" ]] || [[ "$1" == "block" ]]; then
# 		# NORMAL
# 		[[ $CHANGE_CURSOR_SHAPE = true ]] && echo -ne "\e[1 q"
# 		[[ $SHOW_VIMODE = true ]] && echo " %B%F{green}N"
# 	elif [[ "$KEYMAP" =~ ^(main|viins|)$ ]] || [[ "$1" == "beam" ]]; then
# 		# INSERT
# 		[[ $CHANGE_CURSOR_SHAPE = true ]] && echo -ne "\e[5 q"
# 		[[ $SHOW_VIMODE = true ]] && echo " %B%F{cyan}I"
# 	elif [[ "$KEYMAP" == "visual" ]]; then
# 		# VISUAL
# 		[[ $CHANGE_CURSOR_SHAPE = true ]] && echo -ne "\e[3 q"
# 		[[ $SHOW_VIMODE = true ]] && echo " %B%F{orange}V"
# 	fi
# }

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
add-zsh-hook precmd refresh_prompt
