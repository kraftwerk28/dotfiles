if requires nvim; then
	alias vim="nvim"
	alias vi="nvim"
	alias v="nvim"
	alias im="nvim"
	alias vin="nvim"
fi

if requires lsd; then
	alias ls="lsd -F"
	alias la="lsd -Fah"
	alias ll="lsd -Flh"
	alias l="lsd -Flah"
fi

# if type bat > /dev/null; then
# 	alias less="bat"
# fi
alias less="less -i"

if requires bat; then
	alias cat="bat -p --color never --paging never"
fi

alias serves="serve \
	--ssl-cert ~/ca-tmp/localhost.crt \
	--ssl-key ~/ca-tmp/localhost.key"

if [[ -d /usr/lib/jvm ]]; then
	for dir in /usr/lib/jvm/*; do
		if grep -oP "(?<=java-)\d+(?=-openjdk)" <<< $dir | read ver; then
			eval "alias java${ver}=/usr/lib/jvm/${dir}bin/java"
		fi
	done
fi

alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

mkcd () {
	if [[ -z "$1" ]]; then
		echo "Usage: mkcd <dir>" 1>&2
		return 1
	fi
	mkdir -p $1
	cd $1
}
