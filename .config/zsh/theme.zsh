if [[ -z $BASE16_THEME ]]; then
	return 0
fi
theme_file="base16-${BASE16_THEME}.sh"
url="https://raw.githubusercontent.com/chriskempson/base16-shell"
url="$url/master/scripts/$theme_file"
full_path="$HOME/.config/zsh/$theme_file"
if [[ ! -f $full_path ]]; then
	rm -f "$HOME/.config/zsh/base16-*.sh"
	echo "$theme_file is missing, downloading..."
	curl -fso "$full_path" "$url" || echo "Failed to download theme" 1>&2
fi
source "$full_path" 2>/dev/null || echo "Missing theme file" 1>&2
