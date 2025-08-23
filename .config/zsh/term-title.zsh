set_title() {
	printf '\e]2;%s\e\\' $1
}

set_window_title() {
	set_title "$(basename $SHELL) (${PWD/$HOME/"~"}) $1"
}

reset_window_title() {
	set_title "$(basename $SHELL) (${PWD/$HOME/~})"
}

add-zsh-hook precmd reset_window_title
add-zsh-hook preexec set_window_title
