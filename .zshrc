# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/kraftwerk28/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="custom"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  z
  extract
  sudo
  zsh-autosuggestions
)

fpath=(~/.zfunc $fpath)

source "$ZSH/oh-my-zsh.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

PROMPT_END_OK="$"
PROMPT_END_FAIL="$"
GIT_DIRTY="✗"
GIT_CLEAN="✔"
GIT_BRANCH_CH="\Ue0a0"

PROMPT_STATUS="%(?:%B%F{green}$PROMPT_END_OK:%B%F{red}$PROMPT_END_FAIL)"
PROMPT_VIMODE=""

ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{blue}$GIT_BRANCH_CH%b%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f%k "
ZSH_THEME_GIT_PROMPT_DIRTY="%B%F{blue}%F{red}$GIT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{blue}%F{green}$GIT_CLEAN"
CL_RESET="%b%f%k"

source ~/.zsh_completions

alias vim="nvim"
alias vi="nvim"
alias im="nvim"
alias vin="nvim"
alias ndoe="node"

alias dotfiles="git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME/"
dotfilesupd () {
  commit_message=${1:-"Update dotfiles"}
  dotfiles add -u
  dotfiles commit -m $commit_message
  dotfiles push origin HEAD
}

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

mkcd () {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <dirname>"
    return 1
  fi
  mkdir -p "$1"
  cd "$1"
}

cjq () {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <dirname>"
    return 1
  fi
  cat $1 | jq
}

if [[ -s "$NVS_HOME/nvs.sh" ]]; then
  source "$NVS_HOME/nvs.sh"
fi

refresh_prompt () {
  if [ "$KEYMAP" = "vicmd" ] || [ "$1" = "block" ]; then
    echo -ne "\e[1 q"
    # PROMPT_VIMODE="%F{yellow}%SN%s%F{yellow}"
    prompt_vimode="%F{yellow}N "
  elif [ "$KEYMAP" = "main" ] || [ "$KEYMAP" = "viins" ] ||
       [ "$KEYMAP" = "" ] || [ "$1" = "beam" ]; then
    echo -ne "\e[5 q"
    # PROMPT_VIMODE="%F{blue}%SI%s%F{blue}"
    prompt_vimode="%F{blue}I "
  fi
  filepath="%F{#ffa500}%(4~|…/%2~|%~) "
  PROMPT="$filepath\$(git_prompt_info)$prompt_vimode$PROMPT_STATUS$CL_RESET "
  RPROMPT="%F{green}[\$(date +%H:%M:%S)]$CL_RESET"
}

KEYTIMEOUT=50

zle-keymap-select () {
  refresh_prompt $1
  zle reset-prompt
}

zle -N zle-keymap-select
precmd_functions+=(refresh_prompt)

bindkey -v
bindkey "^[OA" up-line-or-history
bindkey "^[OB" down-line-or-history
bindkey "^ " autosuggest-accept
bindkey "^[[Z" reverse-menu-complete
bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^P" up-history
bindkey -M viins "^N" down-history

export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# vim: ft=foo_ft
