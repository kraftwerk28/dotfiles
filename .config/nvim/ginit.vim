" Settings for neovim-qt
packadd neovim-gui-shim
GuiFont! JetBrainsMono NF:h12
GuiTabline 0
GuiPopupmenu 0
GuiAdaptiveColor 1
GuiRenderLigatures 0
nmap <silent> <C-/> gcc
imap <silent> <C-/> <C-O>:normal gcc<CR>
xmap <silent> <C-/> gc