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

" Language
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'davidhalter/jedi-vim'
" Unsub cause it doesn't work
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --ts-completer' }

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
set mouse=a
set mousehide
set nohlsearch

set completeopt=menu,noinsert
set wildmenu
" set wildmode=list:longest

let g:coc_global_extensions = [
  \   'coc-snippets',
  \   'coc-pairs',
  \   'coc-tsserver',
  \   'coc-eslint',
  \   'coc-prettier',
  \   'coc-json',
  \ ]

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:deoplete#enable_at_startup=1
let g:deoplete#enable_ignore_case=1
let g:deoplete#enable_smart_case=1

let NERDTreeQuitOnOpen=1

" Place cursor at the same position
" IDK how this code works
autocmd BufReadPost *
  \  if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

autocmd BufNewFile,BufRead *.{ts,tsx} set filetype=typescript

" Maps
inoremap ii <Esc>
inoremap jj <Esc>
nmap <F3> :NERDTreeToggle<CR>
nmap <Leader>c <plug>NERDCommenterToggle
nmap tt :tabnew<Space>
nmap <silent><C-]> :tabn<CR>
noremap <C-s> :w<CR>
nnoremap <Leader>src :source $HOME/.config/nvim/init.vim<CR>
nnoremap <silent><Leader>/ :nohlsearch<CR>
nnoremap <leader>jsf :!eslint --fix %<CR>
nnoremap <leader>rf :RustFmt<CR>
