set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'junegunn/vim-emoji'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'

" Useful tools
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/csv.vim'

" Language
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'rust-lang/rust.vim'
Plug 'evanleck/vim-svelte'
Plug 'mattn/emmet-vim'
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh'
  \ }

" Plug 'davidhalter/jedi-vim'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Various theming shit
set background=dark
set termguicolors
let ayucolor='mirage'
colorscheme ayu
" let g:gruvbox_contrast_dark='medium'
let g:airline_theme='ayu_mirage'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" Misc
syntax on
set hidden
" Width of the <Tab> character:
set tabstop=4
set softtabstop=2
" Cout of spaces when pressing <Tab>:
set shiftwidth=2
set expandtab
set autoindent
set list
set listchars=tab:->,trail:·
set cursorline
set ignorecase
set termguicolors
set colorcolumn=80
set mouse=a
set mousehide
set clipboard+=unnamed

set incsearch
set nohlsearch
set ignorecase
set smartcase
set wildmenu
" set wildmode=list:longest

set number relativenumber
autocmd Winenter,FocusGained * setlocal number relativenumber
autocmd Winleave,FocusLost * setlocal number norelativenumber
autocmd FocusLost * :wa
set fillchars=vert:\|

let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'javascript.jsx': ['javascript-typescript-stdio'],
  \ }

let g:LanguageClient_rootMarkers = {
  \ 'javascript': ['jsconfig.json'],
  \ 'typescript': ['tsconfig.json'],
  \ }

let g:deoplete#enable_at_startup=1
let g:deoplete#enable_ignore_case=1
let g:deoplete#enable_smart_case=1

let NERDTreeQuitOnOpen=1

" Place cursor at the same position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Close vim if the only window left is NERDTree
autocmd bufenter *
  \ if (winnr("$") == 1 && exists("b:NERDTree") &&
  \   b:NERDTree.isTabTree()) |
  \   q |
  \ endif

autocmd BufNewFile,BufRead *.{ts,tsx} set filetype=typescript

nnoremap <Leader>cfg :tabnew $HOME/.config/nvim/init.vim<CR>
inoremap ii <Esc>
inoremap jj <Esc>
" Arrow movement mappings
nnoremap <Down> <C-e>
nnoremap <Up> <C-y>
nnoremap <S-Up> <C-u>M
nnoremap <S-Down> <C-d>M
nnoremap <C-Up> <C-b>M
nnoremap <C-Down> <C-f>M

nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR> gv
nnoremap > >>
nnoremap < <<
nnoremap tt :tabnew<Space>
nnoremap <silent><C-]> :tabn<CR>
noremap <C-s> :w<CR>
nnoremap <Leader>src :w<CR> :source $HOME/.config/nvim/init.vim<CR>
nnoremap <silent><Leader>/ :nohlsearch<CR>

nnoremap <Leader>jsf :!eslint --fix %<CR>
nnoremap <Leader>rf :RustFmt<CR>

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
