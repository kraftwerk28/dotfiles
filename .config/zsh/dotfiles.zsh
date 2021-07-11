alias dotfiles="git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME/"

dotfilesupd () {
	dotfiles add -u && \
	dotfiles commit "$@" && \
	dotfiles push origin HEAD
}
