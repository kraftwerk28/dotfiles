#!/bin/bash
cursor_theme=$(awk -F= '/Inherits/{print $2}' ~/.icons/default/index.theme)
cursor_theme=${cursor_theme:-Adwaita}
swaymsg -- seat seat0 

