# [@krafterk28](https://github.com/kraftwerk28)'s dotfiles

### Contents:
  - [alacritty config](../.config/alacritty/alacritty.yml)
  - [chrome flags](../.config/chrome-flags.conf)
  - [fontconfig](../.config/fontconfig/fonts.conf)
  - [foot config](../.config/foot/foot.ini)
  - [gost config](../.config/gost/config.yml)
  - [kitty config](../.config/kitty/kitty.conf)
  - [mako config](../.config/mako/config)
  - [neovim configs](../.config/nvim)
  - [openttd configs & saves](../.openttd)
  - [pipewire & ALSA configs](../.config/pipewire)
  - [swaywm configs](../.config/sway)
  - [systemd user units](../.config/systemd/user)
  - [waybar configs](../.config/waybar)
  - [wofi config](../.config/wofi/config)
  - [xdg-desktop-portal-wlr config](../.config/xdg-desktop-portal-wlr/config)
  - [yay config](../.config/yay/config.json)
  - [zsh configs](../.config/zsh) ([.zshrc](../.zshrc))


The directory structure is preserved thanks to `git`'s `--git-dir` and
`--work-tree` flags. To make git stop yelling about tons of untracked files in
your home dir, execute (assuming you have set the
[correct alias](../.config/zsh/dotfiles.zsh) for the `dotfiles`):
```bash
$ dotfiles config status.showUntrackedFiles = no
```
