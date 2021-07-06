alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias im="nvim"
alias vin="nvim"
alias updatenvim="yay -S --needed --noconfirm neovim-git"
alias ndoe="node"
alias nvimcfg="cd $HOME/.config/nvim"

alias ls="lsd -F"
alias la="lsd -Fah"
alias ll="lsd -Flh"
alias l="lsd -Flah"
alias icat="kitty +kitten icat"
alias less="bat"
alias cat="bat -p --color never --paging never"
alias serves="serve \
	--ssl-cert ~/ca-tmp/localhost.crt \
	--ssl-key ~/ca-tmp/localhost.key"
alias ssh="kitty +kitten ssh"

# Java aliases, i.e. java8, java11, ...
for dir in $(ls "/usr/lib/jvm/"); do
  if grep -oP "(?<=java-)\d+(?=-openjdk)" <<< $dir | read ver; then
    eval "alias java${ver}=/usr/lib/jvm/${dir}bin/java"
  fi
done

alias dotfiles="git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME/"
dotfilesupd () {
	dotfiles add -u && \
	dotfiles commit "$@" && \
	dotfiles push origin HEAD
}

alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"

alias ...="../.."
alias ....="../../.."
alias .....="../../../.."
alias ......="../../../../.."

cjq () {
	if [ -z "$1" ]; then
		echo "Usage: mkcd <dirname>"
		return 1
	fi
	cat "$1" | jq
}