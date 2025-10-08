if which nvim &> /dev/null; then
	alias vim="nvim"
	alias vi="nvim"
	alias v="nvim"
	alias im="nvim"
	alias vin="nvim"
fi

if which lsd &> /dev/null; then
	alias ls="lsd -F"
	alias la="lsd -Fah"
	alias ll="lsd -Flh"
	alias l="lsd -Flah"
fi

alias less="less -i"

if which bat &> /dev/null; then
	# alias cat="bat -p --color never --paging never"
	alias cat="bat"
fi

if which git &> /dev/null; then
	alias gst="git status"
	alias gco="git checkout"
	alias gcb="git checkout -b"
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias ssh='TERM=xterm-256color ssh'

alias dotfiles="git --git-dir=$HOME/projects/dotfiles --work-tree=$HOME"

alias pino-pretty="pino-pretty -t 'SYS:dd.mm.yy HH:MM:ss' -i hostname,pid"

dotfilesupd() (
	dotfiles add -u
	dotfiles commit -m "Update dotfiles"
	dotfiles push origin HEAD
)
