node_ver () {
  echo ${$(node -v)/v/}
}

PROMPT_END_OK="$"
PROMPT_END_FAIL="$"
GIT_DIRTY="✗"
GIT_CLEAN="✔"
GIT_BRANCH_CH=""

PROMPT_STATUS="%(?:%B%F{green}$PROMPT_END_OK:%B%F{red}$PROMPT_END_FAIL) "

# NORMAL_LABEL=" N"
# INSERT_LABEL=" I"
# PROMPT_MODE="${${KEYMAP/vicmd/--NORMAL--}/(main|viins)/--INSERT--}"

ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{blue}$GIT_BRANCH_CH%b%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f%k "
ZSH_THEME_GIT_PROMPT_DIRTY="%B%F{blue}%F{red}$GIT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{blue}%F{green}$GIT_CLEAN"

PROMPT='%F{#ffa500}%(4~|…/%2~|%~)%F $(git_prompt_info)'
PROMPT+="$PROMPT_STATUS%b%f%k"

RPROMPT='%F{#080}$(node_ver)%b%f'
