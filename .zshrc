setopt appendhistory autocd

fpath=(~/.zfunc $fpath)

plugdir="/usr/share/zsh/plugins"
source $plugdir/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $plugdir/zsh-z/zsh-z.plugin.zsh
source $plugdir/zsh-extract/extract.plugin.zsh

autoload -U select-word-style
select-word-style bash

for cfg in ~/.config/zsh/*.zsh; do
	source $cfg
done

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

export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1

tabs -4

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
