if ! which jq swaymsg notify-send &> /dev/null; then
	return 1
fi

NOTIFY_COMMAND_COMPLETED_TRESHOLD=2

# Send a notification, if command is executing more than
# NOTIFY_COMMAND_COMPLETED_TRESHOLD seconds and the shell isn't focused

walk_parent_pids() {
	local pids=()
	local cur=$$
	while :; do
		cur="$(awk '{print $4}' "/proc/$cur/stat")"
		if [[ "$cur" == 0 ]]; then
			break
		fi
		pids+=("$cur")
	done
	local IFS=", "
	echo "${pids[*]}"
}

sway_is_shell_focused() {
	swaymsg -t get_tree 2>/dev/null | jq -e \
		' recurse(.nodes[]?, .floating_nodes[]?)
		| select(.pid? as $p | ['"$(walk_parent_pids)"'] | index($p))
		| .focused' &>/dev/null
}

remember_time() {
	PREEXEC_TIMESTAMP="$(date +%s)"
}

notify_on_exit() {
	local exit_code=$?
	if [[ -z $PREEXEC_TIMESTAMP ]]; then
		return
	fi
	local elapsed=$(( $(date +%s) - PREEXEC_TIMESTAMP ))
	if [[ -z $SWAYSOCK ]]; then
		return
	fi
	if (( elapsed >= NOTIFY_COMMAND_COMPLETED_TRESHOLD )) && ! sway_is_shell_focused; then
		if (( exit_code == 0 )); then
			local title="Command succeeded"
		else
			local title="Command failed with code $exit_code"
		fi
		title="$title ($(TZ=GMT+0 date -d "@$elapsed" +'%Hh %Mm %Ss' | sed 's#00\S\s*##g'))"
		local text=$(fc -nl -1)
		notify-send "$title" "$text"
		# Send bell to the terminal:
		echo -n $'\a'
	fi
	unset PREEXEC_TIMESTAMP
}

add-zsh-hook precmd notify_on_exit
add-zsh-hook preexec remember_time
