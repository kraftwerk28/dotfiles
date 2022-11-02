# bindkey -v "^[[A" history-search-backward
# bindkey -v "^[[B" history-search-forward
# bindkey -v "^R" history-incremental-search-backward
# bindkey -v "^[r" history-incremental-search-forward
bindkey -M viins '^R' fzf_history_search
bindkey -M viins '^ ' autosuggest-accept # Control+Space
bindkey -M viins '^[[Z' reverse-menu-complete # Shift+Tab
bindkey -M viins "^H" backward-kill-word
# bindkey -v "^H" vi-backward-kill-word # Shift+Backspace
bindkey -M viins '^I' complete-word
bindkey -M viins -s '^[l' '^uls\n'
bindkey -M viins -s '^[r' '^uranger\n'
# bindkey -M viins '^D' '' # TODO: erase line and feed EOF
bindkey -M viins '^[e' edit-command-line
