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
Plug 'floobits/floobits-neovim'

" Language
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
" Plug 'davidhalter/jedi-vim'
" Plug 'zchee/deoplete-jedi'
Plug 'rust-lang/rust.vim'
Plug 'evanleck/vim-svelte'
Plug 'mattn/emmet-vim'
Plug 'jparise/vim-graphql'
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options

" Various theming shit
set background=dark
set termguicolors
let ayucolor='mirage'
colorscheme ayu

" Misc
syntax on
set hidden
set expandtab tabstop=4 softtabstop=2 shiftwidth=2
set autoindent
set list listchars=tab:->,trail:·
set cursorline
set ignorecase
set termguicolors
set colorcolumn=80
set mousehide mouse=a
set clipboard+=unnamedplus
set completeopt=menuone,longest

set incsearch nohlsearch
set ignorecase smartcase
set wildmenu
set signcolumn=yes
set number relativenumber
set autoread

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Let's

let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'javascript.jsx': ['javascript-typescript-stdio'],
  \ 'python': ['/home/kraftwerk28/.local/bin/pyls'],
  \ }

let g:LanguageClient_rootMarkers = {
  \ 'javascript': ['jsconfig.json'],
  \ 'typescript': ['tsconfig.json'],
  \ }

let g:LanguageClient_useVirtualText = 'CodeLens'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
highlight link EchoDocFloat Pmenu

let NERDTreeQuitOnOpen = 1
let g:AutoPairsFlyMode = 0

let g:airline_theme='ayu_mirage'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let NERDTreeMapOpenInTab="\<CR>"

call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd's

" Place cursor at the same position
function! RestoreCursor()
   if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal! g`\""
   endif
endfunction
autocmd BufReadPost * call RestoreCursor()

" Close vim if the only window left is NERDTree
function! CloseIfNERDTree()
   if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()
     q
   endif
endfunction
autocmd BufEnter * call CloseIfNERDTree()

autocmd Winenter,FocusGained * setlocal number relativenumber
autocmd Winleave,FocusLost * setlocal number norelativenumber
" Exit insert mode if unfocus
autocmd FocusLost * if mode() == "i" | call feedkeys("\<Esc>") | endif | :wa
autocmd BufNewFile,BufRead *.{ts,tsx} set filetype=typescript
" Reload file if it changed on disk
autocmd CursorHold,FocusGained * checktime

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps

nnoremap j gj
nnoremap k gk
inoremap ii <Esc>
inoremap jj <Esc>
nnoremap <Leader>cfg :tabnew $HOME/.config/nvim/init.vim<CR>

" Arrow movement mappings
nnoremap <Down> <C-E>
nnoremap <Up> <C-Y>
nnoremap <S-Up> <C-U>M
nnoremap <S-Down> <C-D>M
nnoremap <C-Up> <C-B>M
nnoremap <C-Down> <C-F>M

nnoremap <silent> <F3> :NERDTreeToggle<CR>
nnoremap <silent> <C-_> :Commentary<CR>
vnoremap <silent> <C-_> :Commentary<CR>gv
inoremap <silent> <C-_> <C-O>:Commentary<CR>

" Indenting
nnoremap > >>
nnoremap < <<
vnoremap > >gv
vnoremap < <gv

nnoremap tt :tabnew<Space>
nnoremap <silent> <C-]> :tabn<CR>
noremap <C-S> :w<CR>
nnoremap <silent> <Leader>src :w<CR> :source $HOME/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Code format
nnoremap <Leader>jsf :w<CR> :!eslint --fix %<CR>
nnoremap <Leader>rf :RustFmt<CR>
nnoremap <Leader>pf :w<CR> :!autopep8 -i %<CR>

inoremap <C-Space> <C-X><C-O>
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <silent> <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<Tab>"

nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+1<CR>

nnoremap <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <Leader>ff :call LanguageClient#textDocument_formatting()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc

" Adds shebang to current file and makes it executable (to current user)
let s:FiletypeExecutables = {
  \ 'python': '/usr/bin/python',
  \ 'javascript': '/usr/bin/node',
  \ 'sh': '/bin/sh',
  \ 'bash': '/bin/bash',
  \ }

function! Shebang()
  let ft = &filetype

  if stridx(getline(1), "#!") == 0
    echo "Shebang already exists."
    return
  endif

  let sys_exec = system("where " . ft)
  if v:shell_error == 0
    let shb = "#!" . sys_exec[:-2]
  elseif has_key(s:FiletypeExecutables, ft)
    let shb = "#!" . s:FiletypeExecutables[ft]
  else
    echoerr "Filename not supported."
    return
  endif
  call append(0, shb)
  w
  silent execute "!chmod u+x %"
endfunction
command! Shebang call Shebang()
