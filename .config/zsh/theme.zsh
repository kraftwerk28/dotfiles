theme_file="base16-${BASE16_THEME:-default-dark}.sh"
url="https://raw.githubusercontent.com/chriskempson/base16-shell"
url="$url/master/scripts/$theme_file"
full_path="$HOME/.config/zsh/$theme_file"
if [[ ! -f $full_path ]]; then
	echo "$theme_file is missing, downloading..."
	curl -f -s -o $full_path $url
fi
source $full_path
