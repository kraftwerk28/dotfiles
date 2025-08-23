manage_venv() {
	local script="$PWD/.venv/bin/activate"
	if [[ -f $script ]]; then
		source $script
	elif which deactivate &> /dev/null; then
		deactivate
	fi
}

add-zsh-hook chpwd manage_venv
manage_venv
