set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'junegunn/vim-emoji'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
" Plug 'morhetz/gruvbox'

" Useful tools
" Sould be replaced by some more useful
" Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/csv.vim'
" Git wrapper
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'

" Language
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'rust-lang/rust.vim'
Plug 'evanleck/vim-svelte'
Plug 'mattn/emmet-vim'
Plug 'jparise/vim-graphql'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh'
  \ }

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options

" Various theming shit
set background=dark
let ayucolor='dark'
" let ayucolor='mirage'
colorscheme ayu

let g:airline_theme='ayu_dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_tabs = 1
" let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Misc
syntax on
set hidden
set expandtab tabstop=4 softtabstop=2 shiftwidth=2
set autoindent
set list listchars=tab:➔\ ,trail:·
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
set autowrite
set foldlevel=99
set foldcolumn=1
set foldmethod=syntax

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Let's

let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'javascript.jsx': ['javascript-typescript-stdio'],
  \ 'python': ['/home/kraftwerk28/.local/bin/pyls'],
  \ 'haskell': ['hie-wrapper', '--lsp'],
  \ 'c': ['clangd'],
  \ 'cpp': ['clangd'],
  \ 'go': ['go-langserver'],
  \ 'sh': ['bash-language-server', 'start'],
  \ 'json': ['vscode-json-languageserver', '--stdio'],
  \ }

let g:LanguageClient_rootMarkers = {
  \ 'javascript': ['jsconfig.json'],
  \ 'typescript': ['tsconfig.json'],
  \ 'haskell': ['*.cabal', 'stack.yaml'],
  \ }

" let g:LanguageClient_useVirtualText = 'CodeLens'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
highlight link EchoDocFloat Pmenu

let NERDTreeQuitOnOpen = 1
let g:AutoPairsFlyMode = 0

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
autocmd FocusLost * if mode() == "i" | call feedkeys("\<Esc>") | endif | wa
" autocmd BufLeave * w

" Reload file if it changed on disk
autocmd CursorHold,FocusGained * checktime

autocmd BufNewFile,BufRead *.{ts,tsx} setlocal filetype=typescript
autocmd FileType go setlocal shiftwidth=4 softtabstop=4 noexpandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps

nnoremap j gj
nnoremap k gk
inoremap ii <Esc>
vnoremap ii <Esc>
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

nnoremap tt :e<Space>
nnoremap <silent> <C-]> :bnext<CR>
nnoremap <silent> <Leader>src :w<CR> :source $HOME/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Code format (languageclient-neovim does it instead)
" nnoremap <Leader>jsf :!eslint --fix %<CR>
" nnoremap <Leader>rf :RustFmt<CR>
" nnoremap <Leader>pf :!autopep8 -i %<CR>
" nnoremap <Leader>cf :!clang-format %<CR>

inoremap <C-Space> <C-X><C-O>
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <silent> <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<Tab>"

nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+1<CR>
vnoremap <silent> <M-k> :m'<-2<CR>gv
vnoremap <silent> <M-j> :m'>+1<CR>gv

function! FormatFile()
  if &filetype == 'json'
    %!jq
  elseif &filetype == 'javascript'
    %!prettier %
  else
    call LanguageClient#textDocument_formatting()
  endif
endfunction
nnoremap <Enter> :call LanguageClient#textDocument_hover()<CR>
nnoremap <F2> :w<CR> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <Leader>ff :call FormatFile()<CR>
nnoremap <silent> <C-LeftMouse> :call LanguageClient#textDocument_definition()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc

" Adds shebang to current file and makes it executable (to current user)
let s:FiletypeExecutables = {
  \ 'javascript': 'node',
  \ }

function! Shebang()
  let ft = &filetype

  if stridx(getline(1), "#!") == 0
    echo "Shebang already exists."
    return
  endif

  let sys_exec = system("which " . ft)
  if v:shell_error == 0
    let shb = "#!/usr/bin/env " . ft
  elseif has_key(s:FiletypeExecutables, ft)
    let shb = "#!/usr/bin/env " . s:FiletypeExecutables[ft]
  else
    echoerr "Filename not supported."
    return
  endif
  call append(0, shb)
  w
  silent execute "!chmod u+x %"
endfunction
command! Shebang call Shebang()

function! Durka()
  let themes = map(
    \ split(system("ls ~/.config/nvim/colors/")) +
    \ split(system("ls /usr/share/nvim/runtime/colors/")),
    \ "v:val[:-5]"
    \)
  for th in themes
    echo th
    execute "colorscheme " . th
    sleep 200m
  endfor
endfunction
