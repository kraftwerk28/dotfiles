" Settings for neovim-qt
packadd neovim-gui-shim
if has("win64")
  GuiFont! Iosevka NF:h12
elseif has("unix")
  GuiFont! Iosevka Term:h12
endif
GuiTabline 0
GuiPopupmenu 0
nmap <silent> <C-/> gcc
imap <silent> <C-/> <C-O>:normal gcc<CR>
xmap <silent> <C-/> gc
