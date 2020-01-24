call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'junegunn/vim-emoji'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'

" Language servers & useful tools
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'rust-lang/rust.vim'

call plug#end()

" Various theming shit
set background=dark
colorscheme gruvbox

let g:gruvbox_contrast_dark='medium'
let g:deoplete#enable_at_startup=1
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

set completefunc=emoji#complete

" Misc
syntax on
set tabstop=4
set shiftwidth=2
set expandtab
set autoindent
set list
set listchars=tab:->,trail:·
set number relativenumber
set cursorline
set ignorecase
set termguicolors
set colorcolumn=80

" Place cursor at the same position
" IDK how this code works
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Keymaps
inoremap ii <Esc>
