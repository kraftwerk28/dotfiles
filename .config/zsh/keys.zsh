bindkey -e

bindkey '^P' up-history
bindkey '^N' down-history
bindkey -M emacs '^ ' autosuggest-accept
bindkey -M emacs "^W" vi-backward-kill-word
bindkey -M viins '^ ' autosuggest-accept
bindkey -M viins '^[[Z' reverse-menu-complete # Shift+Tab
bindkey -M viins "^H" backward-kill-word
bindkey -M viins '^I' complete-word
bindkey -M viins -s '^[l' '^Uls^M'
bindkey -M viins -s '^[r' '^Uranger^M'
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M viins -r '^D'

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^[e' edit-command-line
bindkey -M emacs '^[e' edit-command-line

# Currently unused
set_cursor_style() {
	# # For emacs keymap
	# echo -ne '\e[1 q';;

	case $KEYMAP in
		vicmd)
			# Blinking block
			echo -ne '\e[1 q';;
		main|viins)
			# Blinking beam
			echo -ne '\e[5 q';;
		viopp|visual)
			echo -ne '\e[3 q';;
		*)
			echo -ne '\e[1 q';;
	esac
}

KEYTIMEOUT=5 # 50ms, same as default 'ttimeoutlen' in neovim
