setopt auto_menu
setopt complete_in_word
setopt always_to_end

autoload -Uz compinit
if [[ -n "${ZDOTDIR}/.zcompdump(#qN.mh+24)" ]]; then
	compinit
else
	compinit -C
fi

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
