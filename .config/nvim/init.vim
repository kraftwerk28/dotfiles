set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'tomasr/molokai' 

Plug 'vim-airline/vim-airline-themes'

" Tools
Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree' " File explorer
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf.vim'
Plug 'wellle/targets.vim' " More useful text objects (e.g. function arguments)
Plug 'honza/vim-snippets'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-fugitive' " Git helper
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'lyokha/vim-xkbswitch'
Plug 'diepm/vim-rest-console'

" Languages
Plug 'rust-lang/rust.vim'
Plug 'evanleck/vim-svelte'
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
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/Dockerfile.vim'

" It is required to load devicons as last
Plug 'ryanoasis/vim-devicons'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options

" Set color according to gnome-shell theme
if $XDG_CURRENT_DESKTOP == 'GNOME' &&
\  !(system('gsettings get org.gnome.desktop.interface gtk-theme') =~# 'dark')
  set background=light
  let ayucolor='light'
else
  set background=dark
  let ayucolor='mirage'
endif

colorscheme ayu

if exists('colors_name') && colors_name == 'onedark'
  let g:onedark_terminal_italics = 1
endif

augroup alter_ayu_colorscheme
  autocmd!
  if exists('colors_name ') && colors_name == 'ayu'
    autocmd ColorScheme * highlight VertSplit guifg=#FFC44C
  endif
augroup END
" Must be AFTER augroup above
syntax on

let g:mapleader = ' '

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline configuration

let g:airline_theme = 'ayu_mirage'
" let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#coc#enabled = 1

" Devicons
let g:webdevicons_enable_nerdtree = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsDefaultFolderOpenSymbol = ''
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol=''
let g:DevIconsEnableFolderExtensionPatternMatching = 1


let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,typescript.tsx'

let g:surround_{char2nr('r')} = "{'\r'}"

let g:python_highlight_all = 1

let g:AutoPairsFlyMode = 0

let g:XkbSwitchEnabled = 1
if $XDG_CURRENT_DESKTOP == 'GNOME'
  let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
endif

let g:vim_indent_cont = 0

set hidden
set expandtab tabstop=4 softtabstop=2 shiftwidth=2
set autoindent
set list listchars=tab:➔\ ,trail:·
set ignorecase
set termguicolors
set cursorline colorcolumn=80,120
set mouse=a
set clipboard+=unnamedplus
set completeopt=menuone,longest
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu wildmode=full
set signcolumn=yes " Additional column on left for emoji signs
set number relativenumber
set autoread autowrite autowriteall
set foldlevel=99 foldmethod=syntax
" set foldcolumn=1 " Enable additional column w/ visual folds
set exrc secure " Project-local .nvimrc/.exrc configuration
set scrolloff=2
set diffopt+=vertical
set guicursor=n-v-c-i-ci:block,o:hor50,r-cr:hor30,sm:block
set splitbelow splitright

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd
function! s:RestoreCursor()
   if line("'\"") > 0 && line("'\"") <= line('$')
     exe "normal! g`\""
   endif
endfunction
augroup restore_cursor
  autocmd!
  autocmd BufReadPost * call s:RestoreCursor()
augroup END

augroup auto_save
  autocmd!
  autocmd FocusLost * wall
augroup END

" Reload file if it changed on disk
augroup auchecktime
  autocmd!
  autocmd BufEnter,FocusGained * checktime
augroup END

" Helping nvim detect filetype
let s:additional_ftypes = {
  \ '*.zsh*': 'zsh',
  \ '.env.*': 'sh',
  \ '*.bnf': 'bnf',
  \ '*.webmanifest': 'json'
  \ }

augroup file_types
  autocmd!
  for kv in items(s:additional_ftypes)
    execute 'autocmd BufNewFile,BufRead' kv[0] 'setlocal filetype=' . kv[1]
  endfor

  " Tab configuration for different languages
  autocmd FileType go setlocal shiftwidth=4 softtabstop=4 noexpandtab

  " JSON5's comment
  autocmd FileType json syntax region Comment start="//" end="$"
  autocmd FileType json syntax region Comment start="/\*" end="\*/"
  autocmd FileType json setlocal commentstring=//\ %s

  autocmd FileType markdown setlocal conceallevel=2
augroup END

" List of buf names where q does :q<CR>
let s:q_closes_windows = 'help list git'
let s:disable_line_numbers = 'nerdtree help list'

augroup q_close
  for wname in split(s:q_closes_windows)
    execute 'autocmd FileType' wname 'noremap <silent><buffer> q :q<CR>'
  endfor
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line numbers configuration

function! s:SetNumber(set)
  if index(split(s:disable_line_numbers), &filetype) > -1
    return
  endif
  setlocal number
  if a:set
    setlocal relativenumber
  else
    setlocal norelativenumber
  endif
endfunction

augroup line_numbers
  autocmd!
  autocmd BufEnter,Winenter,FocusGained * call s:SetNumber(1)
  autocmd BufLeave,Winleave,FocusLost * call s:SetNumber(0)
augroup END

" augroup highlight_yank
  " autocmd!
  " autocmd TextYankPost * lua vim.highlight.on_yank()
" augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings

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

" Indenting
nnoremap > >>
nnoremap < <<
vnoremap > >gv
vnoremap < <gv

nnoremap <silent> <M-]> :bnext<CR>
nnoremap <silent> <M-[> :bprevious<CR>
nnoremap <silent> <Leader>src :w<CR> :source ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>cfg :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>h :set hlsearch!<CR>
nnoremap <silent> <Leader>w :wall<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer operations

function! s:buf_filt(inc_cur)
  function! s:f(include_current, idx, val)
    if !bufexists(a:val) || buffer_name(a:val) =~? 'NERD_tree_*'
      return v:false
    endif
    if a:include_current && bufnr() == a:val
      return v:false
    endif
    return v:true
  endfunction
  return filter(range(1, bufnr('$')), function('s:f', [a:inc_cur]))
endfunction

function! s:DelBuf(del_all)
  if (a:del_all)
    wall
    silent execute 'bdelete' join(s:buf_filt(0))
  else
    update
    bprevious | split | bnext | bdelete
  endif
endfunction

function! s:DelAllExcept()
  wall
  silent execute 'bdelete' join(s:buf_filt(1))
endfunction

nnoremap <silent> <Leader>d :call <SID>DelBuf(0)<CR>
nnoremap <silent> <Leader>ad :call <SID>DelBuf(1)<CR>
nnoremap <silent> <Leader>od :call <SID>DelAllExcept()<CR>

nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+1<CR>
vnoremap <silent> <M-k> :m'<-2<CR>gv
vnoremap <silent> <M-j> :m'>+1<CR>gv

" Prettier bindings
function! s:RunPrettier()
  execute 'silent !prettier --write %'
  edit
endfunction
nnoremap <silent> <Leader>pretty :call <SID>RunPrettier()<CR>
vnoremap <Leader>rv :s/\%V

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc configuration
let g:coc_global_extensions = [
  \ 'coc-emmet',
  \ 'coc-snippets',
  \ 'coc-svelte',
  \ ]

highlight link CocWarningHighlight None

function! s:CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

function! s:ExpandCompletion() abort
  if !pumvisible()
    return coc#refresh()
  endif
  " if s:check_back_space()
  "   return "\<Tab>"
  " else
  "   return coc#refresh()
  " endif
endfunction

function! s:SelectCompletion() abort
  if pumvisible()
    return coc#_select_confirm()
  else
    return "\<C-G>u\<CR>"
  endif
endfunction

function! s:CocTab()
  return pumvisible() ? "\<C-N>" : "\<Tab>"
endfunction

function! s:CocShiftTab()
  return pumvisible() ? "\<C-P>" : "\<Tab>"
endfunction

let s:manual_format = {
\   'haskell': 'brittany',
\ }

function! s:FormatCode()
  let l:k = keys(s:manual_format)
  if index(l:k, &filetype) != -1
    update
    normal m"
    execute '%!' . s:manual_format[&filetype] '%'
    normal `"
  else
    call CocAction('format')
  endif
endfunction

" COC actions & completion helpers
inoremap <silent><expr> <Tab> <SID>CocTab()
inoremap <silent><expr> <S-Tab> <SID>CocShiftTab()
inoremap <silent><expr> <C-Space> <SID>ExpandCompletion()
inoremap <silent><expr> <CR> <SID>SelectCompletion()

nnoremap <silent> <Leader>ah :call CocAction('doHover')<CR>
nnoremap <silent> <Leader>aj :call CocAction('jumpDefinition')<CR>
nnoremap <silent> <C-LeftMouse> :call CocAction('jumpDefinition')<CR>
nnoremap <silent> <F2> :call CocAction('rename')<CR>
nnoremap <silent> <Leader>f :call <SID>FormatCode()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Embedded terminal

nnoremap <Leader>` :10split terminal<CR>

augroup terminal_insert
  autocmd!
  autocmd TermOpen * startinsert
"   autocmd TermClose * wincmd c
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc commands & functions

" Adds shebang to current file and makes it executable (to current user)
let s:filetype_executables = { 'javascript': 'node' }

function! s:Shebang()
  write
  execute 'silent !chmod u+x %'

  if stridx(getline(1), "#!") == 0
    echo 'Shebang already exists.'
    return
  endif
  execute 'silent !which' &filetype
  if v:shell_error == 0
    let shb = '#!/usr/bin/env ' . &filetype
  elseif has_key(s:filetype_executables, &filetype)
    let shb = '#!/usr/bin/env ' . s:filetype_executables[&filetype]
  else
    echoerr 'Filename not supported.'
    return
  endif
  call append(0, shb)
  update
endfunction
command! -nargs=0 Shebang call s:Shebang()

function! Durka()
  let themes = map(
    \ split(system("ls ~/.config/nvim/colors/")) +
    \ split(system("ls /usr/share/nvim/runtime/colors/")),
    \ "v:val[:-5]"
    \ )
  for th in themes
    echo th
    execute 'colorscheme' th
    sleep 200m
  endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Case-tools

" shake_case -> camelCase
nmap <silent> <Leader>cc viw<Leader>cc
vnoremap <silent> <Leader>cc :s/\%V_\(.\)/\U\1/g<CR>

" snake_case -> PascalCase
nmap <silent> <Leader>pc viw<Leader>pc
vmap <silent> <Leader>pc <Leader>cc`<vU

" camelCase/PascalCase -> snake_case
nmap <silent> <Leader>sc viw<Leader>sc
vnoremap <silent> <Leader>sc :s/\%V\(\l\)\(\u\)/\1_\l\2/g<CR>`<vu

" snake_case -> kebab-case
" TODO: implement

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree configuration

" Preserve netrw to load
let g:loaded_netrwPlugin = 1

let NERDTreeCascadeSingleChildDir = 0
let NERDTreeMouseMode = 2
let NERDTreeQuitOnOpen = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore = ['__pycache__$', '\.git$', '\~$']
let NERDTreeHijackNetrw = 0
let NERDTreeDirArrowCollapsible = ''
" let NERDTreeDirArrowCollapsible = ''
let NERDTreeDirArrowExpandable = ''
" let NERDTreeDirArrowExpandable = ''

function! s:AutoOpenNERDTree()
  if argc() == 0 && !exists('s:std_in')
    NERDTree
  elseif argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in')
    wincmd p
    enew
    exe 'NERDTree' argv()[0]
  endif
endfunction

function! s:CloseNERDTreeAlone()
  if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()
    qall
  endif
endfunction

function! s:ToggleNERDTree(is_leader)
  if a:is_leader
    if g:NERDTree.IsOpen()
      NERDTreeClose
    else
      NERDTreeFind
      execute 'vertical resize' g:NERDTreeWinSize
    endif
  else
    if &filetype == 'nerdtree'
      NERDTreeClose
    else
      NERDTreeCWD
      execute 'vertical resize' g:NERDTreeWinSize
    endif
  endif
endfunction

nnoremap <silent> <F3> :call <SID>ToggleNERDTree(0)<CR>
nnoremap <silent> <Leader><F3> :call <SID>ToggleNERDTree(1)<CR>

augroup nerdtree
  autocmd!

  autocmd FileType nerdtree nnoremap <buffer><silent> <Esc> :NERDTreeClose<CR>
  autocmd FileType nerdtree nnoremap <buffer><silent> q :NERDTreeClose<CR>

  autocmd StdinReadPre * let s:std_in = 1
  " autocmd VimEnter * call s:AutoOpenNERDTree()
  autocmd BufEnter * call s:CloseNERDTreeAlone()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDCommenter configuration

let NERDSpaceDelims = 1
let NERDDefaultAlign = 'start'
nnoremap <silent> <C-_> :call NERDComment('n', 'Toggle')<CR>
vnoremap <silent> <C-_> :call NERDComment('v', 'Toggle')<CR>gv
inoremap <silent> <C-_> <C-O>:call NERDComment('i', 'Toggle')<CR>

let g:NERDCustomDelimiters = {
\   'javascriptreact': {
\     'leftAlt': '{/*',
\     'rightAlt': '*/}',
\   },
\   'typescript.tsx': {
\     'left': '//',
\     'right': '',
\     'leftAlt': '{/*',
\     'rightAlt': '*/}',
\   },
\ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF configuration

let $FZF_DEFAULT_COMMAND = "rg --files --hidden --ignore"
nnoremap <C-P> :Files<CR>
nnoremap <Leader>rg :Rg<CR>
nnoremap <Leader>b :Buffers<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git bindings

nnoremap <silent> <Leader>gm :Gdiffsplit!<CR>
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <Leader>gp :10split <Bar> :terminal git push origin HEAD<CR>
nnoremap <silent> <Leader>m[ :diffget //2<CR>
nnoremap <silent> <Leader>m] :diffget //3<CR>
