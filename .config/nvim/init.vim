set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'junegunn/vim-emoji'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
" Plug 'morhetz/gruvbox'

" Useful tools
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/csv.vim'
Plug 'alvan/vim-closetag'
Plug 'wellle/targets.vim'
" Git wrapper
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'

" Language
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/echodoc.vim'
Plug 'rust-lang/rust.vim'
Plug 'evanleck/vim-svelte'
Plug 'mattn/emmet-vim'
Plug 'jparise/vim-graphql'
Plug 'cespare/vim-toml'
Plug 'ollykel/v-vim'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
" Plug 'autozimu/LanguageClient-neovim', {
"   \ 'branch': 'next',
"   \ 'do': 'bash install.sh'
"   \ }

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options

" Various theming shi~
if !(system('gsettings get org.gnome.desktop.interface gtk-theme') =~# "dark")
  set background=light
  let ayucolor='light'
else
  set background=dark
  let ayucolor='mirage'
  " let ayucolor='dark'
endif

colorscheme ayu

let g:airline_theme='ayu_mirage'
" let g:airline_theme='ayu_dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,typescript.tsx'
let g:surround_{char2nr('r')} = "{'\r'}"

let g:user_emmet_leader_key='<Leader>e'

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
set ignorecase
" set smartcase
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

" let g:LanguageClient_useVirtualText = 'CodeLens'

" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_ignore_case = 1
" call deoplete#custom#option('smart_case', v:true)

" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'floating'
" highlight link EchoDocFloat Pmenu

highlight link CocWarningHighlight None

let NERDTreeQuitOnOpen = 1
let g:NERDTreeHijackNetrw = 0
let g:AutoPairsFlyMode = 0

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
autocmd FocusLost * wa
" The thing above also goes into normal mode if window lost focus
" autocmd FocusLost * if mode() == "i" | call feedkeys("\<Esc>") | endif | wa

" Reload file if it changed on disk
autocmd CursorHold,FocusGained * checktime

" Helping nvim detect filetype
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
autocmd BufNewFile,BufRead *.zsh* setlocal filetype=zsh
autocmd BufNewFile,BufRead .env.* setlocal filetype=sh
autocmd BufNewFile,BufRead *.bnf setlocal filetype=bnf

" Tab configuration for different languages
autocmd FileType go setlocal shiftwidth=4 softtabstop=4 noexpandtab

" JSON5's comment
autocmd FileType json syntax match Comment +\/\/.\+$+

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps

" The block above WON'T execute in vscode-vim extension,
" so thath's why I use it
if has('nvim')
  nnoremap j gj
  nnoremap k gk
  nnoremap gj j
  nnoremap gk k
endif

inoremap ii <Esc>
vnoremap ii <Esc>

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

nnoremap <Leader>/ :set hlsearch!<CR>

nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+1<CR>
vnoremap <silent> <M-k> :m'<-2<CR>gv
vnoremap <silent> <M-j> :m'>+1<CR>gv


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

function! ExpandCompletion() abort
  if pumvisible()
    return "\<C-N>"
  else
    " return coc#refresh()
    if s:check_back_space()
      return "\<Tab>"
    else
      return coc#refresh()
    endif
  endif
endfunction

function! SelectCompletion() abort
  if pumvisible()
    return coc#_select_confirm()
  else
    return "\<C-G>u\<CR>"
  endif
endfunction

" COC actions & completion helpers
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<Tab>"
inoremap <silent><expr> <C-Space> ExpandCompletion()
inoremap <silent><expr> <CR> SelectCompletion()
nnoremap <silent> <Enter> :call CocAction('doHover')<CR>
nnoremap <silent> <F2> :w<CR> :call CocAction('rename')<CR>
nnoremap <silent> <Leader>f :call CocAction('format')<CR>
nnoremap <silent> <C-LeftMouse> :call CocAction('jumpDefinition')<CR>

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
