call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-emoji'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'rust-lang/rust.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'

call plug#end()

let g:deoplete#enable_at_startup = 1

let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"let ayucolor = 'dark'
let g:onedark_terminal_italics = 1
colorscheme gruvbox

set completefunc=emoji#complete

syntax on
set tabstop=4
set shiftwidth=2
set expandtab
set autoindent
set listchars=tab:->,trail:·
set list
set nu
set rnu
set cursorline
set completeopt=noinsert
set ignorecase
set termguicolors
"set omnifunc=syntaxcomplete#Complete

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
