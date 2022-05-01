requires jq swaymsg notify-send || return

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

is_shell_focused() {
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
	local diff="$(( $(date +%s) - PREEXEC_TIMESTAMP ))"
	if (( diff >= NOTIFY_COMMAND_COMPLETED_TRESHOLD )) && ! is_shell_focused; then
		if [[ $exit_code == 0 ]]; then
			local title="Command succeeded"
		else
			local title="Command failed with code $exit_code"
		fi
		local time_passed=$(date -d "@$diff" +"%Mm %Ss" | sed 's/\s*00\w\s*//')
		title="$title ($time_passed)"
		local text=$(fc -nl -1)
		notify-send "$title" "$text"
		# Send bell to the terminal:
		echo $'\a'
	fi
	PREEXEC_TIMESTAMP=
}

add-zsh-hook precmd notify_on_exit
add-zsh-hook preexec remember_time
