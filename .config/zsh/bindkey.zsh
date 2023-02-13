bindkey -v

KEYTIMEOUT=5 # 50ms, same as default 'ttimeoutlen' in neovim

# $ZVM_CURSOR_BLOCK) style='\e[2 q';;
# $ZVM_CURSOR_UNDERLINE) style='\e[4 q';;
# $ZVM_CURSOR_BEAM) style='\e[6 q';;
# $ZVM_CURSOR_BLINKING_BLOCK) style='\e[1 q';;
# $ZVM_CURSOR_BLINKING_UNDERLINE) style='\e[3 q';;
# $ZVM_CURSOR_BLINKING_BEAM) style='\e[5 q';;
# $ZVM_CURSOR_USER_DEFAULT) style='\e[0 q';;

# _keymap_handler() {
# 	case "$KEYMAP" in
# 		viins|main) echo -en "\e[5 q";;
# 		visual|viopp) echo -en "\e[3 q";;
# 		*) echo -en "\e[1 q";;
# 	esac
# }
# zle -N zle-keymap-select _keymap_handler
# zle -N zle-line-init _keymap_handler

# bindkey -v "^[[A" history-search-backward
# bindkey -v "^[[B" history-search-forward
# bindkey -v "^R" history-incremental-search-backward
# bindkey -v "^[r" history-incremental-search-forward
bindkey -M viins '^ ' autosuggest-accept
bindkey -M viins '^[[Z' reverse-menu-complete # Shift+Tab
bindkey -M viins "^H" backward-kill-word
# bindkey -v "^H" vi-backward-kill-word # Shift+Backspace
bindkey -M viins '^I' complete-word
bindkey -M viins -s '^[l' '^uls\n'
bindkey -M viins -s '^[r' '^uranger\n'

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^[e' edit-command-line

bindkey -M viins '^R' fzf_history_search
bindkey -M viins '^S' history-incremental-search-forward
