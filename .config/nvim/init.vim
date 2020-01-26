set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')
" Themes
Plug 'junegunn/vim-emoji'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'

"Language servers & useful tools
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'davidhalter/jedi-vim'
Plug 'mattn/emmet-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'rust-lang/rust.vim'
call plug#end()

"Various theming shit
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='medium'
let g:airline_theme='ayu'
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

"Misc
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

set completeopt+=noinsert
"set wildmode=list:longest

let g:deoplete#enable_at_startup=1
let g:deoplete#enable_ignore_case=1
let g:deoplete#enable_smart_case=1

let NERDTreeQuitOnOpen=1

"Place cursor at the same position
"IDK how this code works
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g`\""
\| endif

" Maps
imap ii <Esc>
map <F3> :NERDTreeToggle<CR>
nmap <Leader>c <plug>NERDCommenterToggle
nmap tt :tabnew<Space>
nmap <C-]> :tabn<CR>
nmap <C-[> :tabp<CR>
nmap <C-w> :tabclose<CR>
