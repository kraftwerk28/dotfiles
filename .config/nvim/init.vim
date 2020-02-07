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
Plug 'tpope/vim-commentary'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/csv.vim'

" Language
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi'
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

set incsearch
set hlsearch
set ignorecase
set smartcase

set completeopt=menu,noinsert
set wildmenu
" set wildmode=list:longest
set number relativenumber
autocmd winenter,focusgained * setlocal number relativenumber
autocmd winleave,focuslost * setlocal number norelativenumber

let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'javascript.jsx': ['javascript-typescript-stdio'],
  \ 'python': ['pyls'],
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
" IDK how this code works
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

autocmd BufNewFile,BufRead *.{ts,tsx} set filetype=typescript

nnoremap <Leader>cfg :tabnew $HOME/.config/nvim/init.vim<CR>

inoremap ii <Esc>
inoremap jj <Esc>
nnoremap <Down> <C-e>
nnoremap <Up> <C-y>
nnoremap <S-Up> M<C-u>
nnoremap <S-Down> M<C-d>

nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <Leader>c <plug>NERDCommenterToggle

nnoremap tt :tabnew<Space>
nnoremap <silent><C-]> :tabn<CR>
noremap <C-s> :w<CR>
nnoremap <Leader>src :w<CR> :source $HOME/.config/nvim/init.vim<CR>
nnoremap <silent><Leader>/ :nohlsearch<CR>

nnoremap <Leader>jsf :!eslint --fix %<CR>
nnoremap <Leader>rf :RustFmt<CR>
