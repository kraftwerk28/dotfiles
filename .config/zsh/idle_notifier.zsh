#!/usr/bin/env zsh

# Send a notification, if command is executing more than
# NOTIFY_COMMAND_COMPLETED_TRESHOLD seconds and the shell isn't focused

walk_parent_pids() {
	local pids=($$)
	local cur=$$
	while true; do
		local ppid=$(awk '{print $4}' /proc/$cur/stat)
		pids+=($ppid)
		cur=$ppid
		if [[ $ppid = 0 ]]; then
			break
		fi
	done
	local IFS=", "
	echo "${pids[*]}"
}

is_shell_focused() {
	local focused=$(
	swaymsg -t get_tree \
		| jq -r \
		' ..
		| objects
		| select(.pid? as $p | ['$(walk_parent_pids)'] | index($p)).focused'
	)
	[[ $focused = "true" ]]
}

remember_time() {
	PREEXEC_TIMESTAMP=$(date +%s)
}

notify_if_needed() {
	local exit_code=$?
	if [[ -z "$PREEXEC_TIMESTAMP" ]]; then
		return
	fi
	local diff=$(($(date +%s) - $PREEXEC_TIMESTAMP))
	if (( $diff >= $NOTIFY_COMMAND_COMPLETED_TRESHOLD )) && ! is_shell_focused
	then
		if [[ $exit_code == 0 ]]; then
			local title="Command succeeded"
		else
			local title="Command failed (code: $exit_code)"
		fi
		local time_passed=$(date -d "@$diff" +"%Mm %Ss")
		local title="$title ($time_passed)"
		local text=$(fc -nl -1)
		notify-send $title $text
	fi
	PREEXEC_TIMESTAMP=
}

autoload -U add-zsh-hook
add-zsh-hook precmd notify_if_needed
add-zsh-hook preexec remember_time
