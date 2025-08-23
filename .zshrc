dot_config="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
local_plugin_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins"

autoload -U add-zsh-hook

source "$dot_config/options.zsh"
source "$dot_config/completion.zsh"
source "$dot_config/keys.zsh"
source "$dot_config/alias.zsh"
source "$dot_config/idle_notifier.zsh"
source "$dot_config/prompt.zsh"
source "$dot_config/venv.zsh"
source "$dot_config/term-title.zsh"

# Simple plugin management
plug() {
	local plug=$1
	local plugdirs=("$local_plugin_dir" "/usr/share/zsh/plugins")
	for dir in "${plugdirs[@]}"; do
		local plug_file=($dir/$plug/*.plugin.zsh(N[1]))
		if [[ -f "$plug_file" ]]; then
			source "$plug_file"
			return
		fi
	done
	echo "Plugin $plug not found. Please install it"
}

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
plug zsh-autosuggestions

# zvm_config() {
# 	# ZVM_TERM=xterm-256color
# 	ZVM_CURSOR_STYLE_ENABLED=true
# 	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# 	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
# 	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
# 	# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# 	# ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
# }
# plug zsh-vi-mode

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

tabs -4

# WORDCHARS='-'

# Dump working directory for using in sway keybindings, i.e. $mod+Shift+Enter
dump_cwd() {
	if [[ $PWD != $HOME ]]; then
		echo "$PWD" > /tmp/last-cwd
	fi
}
add-zsh-hook precmd dump_cwd

# Foot terminal fix
foot_quirk() {
	# Disable reverse wrapping mode in foot terminal
	echo -n "\e[?45l"
}
add-zsh-hook precmd foot_quirk

mkcd() {
	if [[ -z "$1" ]]; then
		echo "Usage: mkcd <dir>" 1>&2
		return 1
	fi
	mkdir -p "$1"
	cd "$1"
}

ytd() {
	args=("$@")
	if [[ $# -eq 0 ]] && wl-paste -l | grep "text/plain" >/dev/null; then
		args+=("$(wl-paste)")
	fi
	yt-dlp "${args[@]}"
}

if which zoxide &> /dev/null; then
	eval "$(zoxide init zsh)"
fi

if which fnm &> /dev/null; then
	eval "$(fnm env --use-on-cd --shell=zsh --resolve-engines=false)"
fi

if which pyenv &> /dev/null; then
	export PYENV_ROOT=$HOME/.pyenv
	if [[ -d $PYENV_ROOT/bin ]]; then
		export PATH=$PYENV_ROOT/bin:$PATH
	fi
	eval "$(pyenv init -)"
fi

if which paru &> /dev/null; then
	alias yay=paru
fi

if which fzf &> /dev/null; then
	FZF_CTRL_R_OPTS="--reverse --cycle"
	source <(fzf --zsh)
fi

# FIXME: for some reason, this doesn't work
# if which fnm &> /dev/null; then
# 	eval "$(fnm env --use-on-cd)"
# fi

get_idf() {
	source $HOME/projects/esp/esp-idf/export.sh
	# sudo sysctl -w dev.tty.legacy_tiocsti=1
}

imv_dir() {
	if (( $# > 1 )); then
		exit 1
	fi
	dir=$(dirname $1)
	imv -n "$1" $dir/*.{jpg,jpeg,png}
}

reboot-win10() {
	systemctl reboot --boot-loader-entry=windows10.conf
}

export QSYS_ROOTDIR="/home/kraftwerk28/.cache/paru/clone/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/24.1/quartus/sopc_builder/bin"
export LS_COLORS="$(vivid generate gruvbox-light)"
