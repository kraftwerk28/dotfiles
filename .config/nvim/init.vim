set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline-themes'

Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
" File tree explorer:
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'wellle/targets.vim'
Plug 'honza/vim-snippets'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'lyokha/vim-xkbswitch'

" Languages
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
Plug 'chrisbra/csv.vim'
Plug 'vim-python/python-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'plasticboy/vim-markdown'

" It is required to load devicons as last
Plug 'ryanoasis/vim-devicons'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options

" Set color according to gnome-shell theme
if !(system('gsettings get org.gnome.desktop.interface gtk-theme') =~# "dark")
  set background=light
  let ayucolor='light'
else
  set background=dark
  let ayucolor='mirage'
  " let ayucolor='dark'
endif

colorscheme ayu
" colorscheme gruvbox

" Airline
let g:airline_theme = 'ayu_mirage'
" let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#coc#enabled = 1

let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,typescript.tsx'

let g:surround_{char2nr('r')} = "{'\r'}"

let g:user_emmet_leader_key='<Leader>e'

let g:python_highlight_all = 1

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
set smartcase
set wildmenu
set signcolumn=yes
set number relativenumber
set autoread
set autowrite
set foldlevel=99
set foldcolumn=1
set foldmethod=syntax

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_global_extensions = [
  \ 'coc-emmet',
  \ 'coc-snippets',
  \ 'coc-svelte',
  \ ]

highlight link CocWarningHighlight None

let NERDTreeCascadeSingleChildDir = 0
let NERDTreeMouseMode = 2
" let NERDTreeMapActivateNode = 'go'
" let NERDTreeMapPreview = 'o'
let g:AutoPairsFlyMode = 0

let g:XkbSwitchEnabled = 1
if $XDG_CURRENT_DESKTOP == "GNOME"
  let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd's

" Place cursor at the same position
function! RestoreCursor()
   if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal! g`\""
   endif
endfunction
autocmd BufReadPost * call RestoreCursor()

" NerdTree au tweaks
function! CloseIfNERDTree()
   if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()
     q
   endif
endfunction

function! AutoOpenNerdTree()
  if argc() == 0 && !exists("s:std_in")
    NERDTree
  elseif argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    wincmd p
    ene
    exe 'NERDTree' argv()[0]
  endif
endfunction

autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * call AutoOpenNerdTree()
autocmd BufEnter * call CloseIfNERDTree()

function SetNumber(set)
  if !exists("b:NERDTree")
    setlocal number
    if a:set
      setlocal relativenumber
    else
      setlocal norelativenumber
    endif
  endif
endfunction
autocmd Winenter,FocusGained * :call SetNumber(1)
autocmd Winleave,FocusLost * :call SetNumber(0)

" Exit insert mode if unfocus
autocmd FocusLost * silent! w
" The thing below also goes into normal mode if window lost focus
" autocmd FocusLost * if mode() == "i" | call feedkeys("\<Esc>") | endif | wa

" Reload file if it changed on disk
autocmd CursorHold,FocusGained * checktime

" Helping nvim detect filetype
" autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
" autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
autocmd BufNewFile,BufRead *.zsh* setlocal filetype=zsh
autocmd BufNewFile,BufRead .env.* setlocal filetype=sh
autocmd BufNewFile,BufRead *.bnf setlocal filetype=bnf

" Tab configuration for different languages
autocmd FileType go setlocal shiftwidth=4 softtabstop=4 noexpandtab

" JSON5's comment
autocmd FileType json syntax match Comment +\/\/.\+$+

" List of buf names where q does :q<CR>
let qCloseWindows = ['help']
" Close help window w/ `q`
for wname in qCloseWindows
  execute "autocmd FileType " . wname . " noremap <silent><buffer> q :q<CR>"
endfor

function! RefreshNERDTree()
  NERDTreeFocus
  normal R
  wincmd p
endfunction
autocmd BufWritePost * :call RefreshNERDTree()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps

" The block below WON'T execute in vscode-vim extension,
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

function OpenNERDTree()
  if exists("b:NERDTree")
    NERDTreeClose
    set updatetime&
  else
    NERDTreeCWD
    set updatetime=200
  endif
endfunction
nnoremap <silent> <F3> :call OpenNERDTree()<CR>
noremap <C-P> :Files<CR>

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
nnoremap <silent> <C-[> :bprevious<CR>
nnoremap <silent> <Leader>src :w<CR> :source $HOME/.config/nvim/init.vim<CR>

nnoremap <silent> <Leader>h :set hlsearch!<CR>

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
    return coc#refresh()
    " if s:check_back_space()
    "   return "\<Tab>"
    " else
    "   return coc#refresh()
    " endif
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
  call system("chmod u+x " . expand('%'))
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

command! Cfg :execute ":e $HOME/.config/nvim/init.vim"

" Doesn't work because of passwd prompt (need workaround)
" command W :execute "w !sudo tee %" | :e!
