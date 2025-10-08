manage_venv() {
	local dir="$PWD"
	while [[ $dir != "/" ]]; do
		local ascript="$dir/.venv/bin/activate"
		if [[ -f "$ascript" ]]; then
			if [[ -z "$VIRTUAL_ENV" ]]; then
				source "$ascript"
			fi
			return
		fi
		dir="$(dirname "$dir")"
	done

	if which deactivate &>/dev/null; then
		deactivate
	fi
}

add-zsh-hook chpwd manage_venv
manage_venv
