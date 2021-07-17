alias dotfiles="git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME/"
compdef dotfiles="git"

dotfilesupd () {
	dotfiles add -u && \
	dotfiles commit "$@" && \
	dotfiles push origin HEAD
}
