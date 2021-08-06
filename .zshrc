fpath=(~/.zfunc $fpath)

plug () {
	local plugfile=/usr/share/zsh/plugins/$1
	[[ -f $plugfile ]] && source $plugfile
}

plug zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
plug zsh-z/zsh-z.plugin.zsh
plug zsh-extract/extract.plugin.zsh
plug zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Change cursor shape depending on vi mode
CHANGE_CURSOR_SHAPE=0
# Show a character depending on vi mode
SHOW_VIMODE=1
KEYTIMEOUT=1

autoload -U select-word-style
select-word-style bash
setopt appendhistory autocd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZVM_CURSOR_STYLE_ENABLED=false

tabs -4

if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
	source /etc/profile.d/vte.sh
fi

for cfg in ~/.config/zsh/*.zsh; do
	source $cfg
done

bindkey -v
bindkey "^[OA" up-line-or-history
bindkey "^[OB" down-line-or-history
bindkey "^ " autosuggest-accept
bindkey "^[[Z" reverse-menu-complete
bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^P" up-history
bindkey -M viins "^N" down-history
bindkey -M viins "^H" backward-kill-word
bindkey -s "^[l" "ls\n"

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh" --no-use
fi

dump_cwd () {
	echo $(pwd) > /tmp/last_pwd
}
precmd_functions+=(dump_cwd)
