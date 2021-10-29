requires curl || return
if [[ -z $BASE16_THEME ]]; then
	return 0
fi
theme_file="base16-${BASE16_THEME}.sh"
full_path="$HOME/.config/zsh/base16/$theme_file"
if [[ ! -f $full_path ]]; then
	mkdir -p $(dirname $full_path)
	echo "$theme_file is missing, downloading..."
	url="https://raw.githubusercontent.com/chriskempson/base16-shell"
	url="$url/master/scripts/$theme_file"
	curl -fso "$full_path" "$url" || echo "Failed to download theme" 1>&2
fi
source "$full_path" 2>/dev/null || echo "Missing theme file" 1>&2
