if (( $+commands[nvim] )); then
	alias vim="nvim"
	alias vi="nvim"
	alias v="nvim"
	alias im="nvim"
	alias vin="nvim"
fi

if (( $+commands[lsd] )); then
	alias ls="lsd -F"
	alias la="lsd -Fah"
	alias ll="lsd -Flh"
	alias l="lsd -Flah"
fi

alias less="less -i"

(( $+commands[bat] )) && alias cat="bat -p --color never --paging never"

# if [[ -d /usr/lib/jvm ]]; then
# 	for dir in /usr/lib/jvm/*; do
# 		if grep -oP "(?<=java-)\d+(?=-openjdk)" <<< $dir | read ver; then
# 			eval "alias java${ver}=/usr/lib/jvm/${dir}bin/java"
# 		fi
# 	done
# fi

if (( $+commands[git] )); then
	alias gst="git status"
	alias gco="git checkout"
	alias gcb="git checkout -b"
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias ssh='TERM=xterm-256color ssh'

if (( $+commands[docker] )); then
	alias dco='docker compose'
fi
