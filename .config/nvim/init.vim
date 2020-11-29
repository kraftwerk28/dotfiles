let $CI = 1
set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

" Themes
Plug 'ayu-theme/ayu-vim'
" Plug 'joshdick/onedark.vim'
" Plug 'dracula/vim', {'as': 'dracula'}
" Plug 'tomasr/molokai' 
Plug 'vim-airline/vim-airline-themes'
" Plug 'rakr/vim-one'

" Tools
Plug 'vim-airline/vim-airline'
" Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree' " File explorer
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'wellle/targets.vim' " More useful text objects (e.g. function arguments)
Plug 'honza/vim-snippets'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-fugitive' " Git helper
Plug 'airblade/vim-gitgutter'
" Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'lyokha/vim-xkbswitch'
Plug 'diepm/vim-rest-console'
Plug 'chrisbra/Colorizer'

" Languages
"----------- This is obsolette as had been replaced by vim-polyglot -----------"
" Plug 'rust-lang/rust.vim'
" Plug 'evanleck/vim-svelte'
" Plug 'jparise/vim-graphql'
" Plug 'cespare/vim-toml'
" Plug 'ollykel/v-vim'
" Plug 'pangloss/vim-javascript'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'maxmellon/vim-jsx-pretty'
" Plug 'chrisbra/csv.vim'
" Plug 'vim-python/python-syntax'
" Plug 'plasticboy/vim-markdown'
" Plug 'ekalinin/Dockerfile.vim'
" Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'leafgarland/typescript-vim'
" Plug 'HerringtonDarkholme/yats.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'

" Plug 'leafgarland/typescript-vim'
" let g:polyglot_disabled = ['typescript']
" Plug 'sheerun/vim-polyglot'

" Nightly 0.5.x stuff
Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'

" It is required to load devicons as last
Plug 'ryanoasis/vim-devicons'

call plug#end()

lua require('init')

"---------------------------------- Theme -------------------------------------"
" 
set termguicolors
if $XDG_CURRENT_DESKTOP == 'GNOME' &&
  \ !(system('gsettings get org.gnome.desktop.interface gtk-theme') =~# 'dark')
  set background=light
  let ayucolor = 'light'
else
  set background=dark
  let ayucolor = 'dark'
endif

colorscheme ayu
let g:lightline = {
                \   'colorscheme': 'ayu_dark',
                \   'separator': { 'left': '', 'right': '' },
                \   'subseparator': { 'left': '', 'right': '' },
                \ }

if exists('colors_name') && colors_name == 'onedark'
  let g:onedark_terminal_italics = 1
endif

augroup alter_ayu_colorscheme
  autocmd!
  if exists('colors_name') && colors_name == 'ayu'
    autocmd ColorScheme * highlight VertSplit guifg=#FFC44C
  endif
augroup END

" Must be AFTER augroup above
syntax on

let g:mapleader = ' '

"--------------------------- Airline configuration ----------------------------"
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_theme = 'ayu_dark'
let g:airline_extensions = ['tabline', 'coc']
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline#extensions#tabline#left_sep = ''
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#right_sep = ''
" let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

"--------------------------- Devicos configuration ----------------------------"
let g:webdevicons_enable_nerdtree = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsDefaultFolderOpenSymbol = ''
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol=''
let g:DevIconsEnableFolderExtensionPatternMatching = 1

" let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,typescript.tsx'

let g:surround_{char2nr('r')} = "{'\r'}"
let g:surround_{char2nr('j')} = "{/* \r */}"
let g:surround_{char2nr('c')} = "/* \r */"

let g:python_highlight_all = 1

let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0

let g:XkbSwitchEnabled = 1
if $XDG_CURRENT_DESKTOP == 'GNOME'
  let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
endif

let g:vim_indent_cont = 0

let g:javascript_plugin_jsdoc = 1

"---------------------------------- Options -----------------------------------"
set hidden
set expandtab tabstop=4 softtabstop=2 shiftwidth=2
set autoindent smartindent
set list listchars=tab:➔\ ,trail:·
set ignorecase
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
set foldlevel=99 foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldcolumn=1 " Enable additional column w/ visual folds

set exrc secure " Project-local .nvimrc/.exrc configuration
set scrolloff=2
set diffopt+=vertical
" set guicursor=n-v-c-i-ci:block,o:hor50,r-cr:hor30,sm:block
set splitbelow splitright
set regexpengine=0
set lazyredraw
set guifont=JetBrains\ Mono\ Nerd\ Font:h18
" set showtabline=1
" set shada='1000,%

"---------------------------------- Autocmd -----------------------------------"
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
  autocmd FocusLost * silent! wa
augroup END

" Reload file if it changed on disk
augroup auchecktime
  autocmd!
  autocmd BufEnter,FocusGained * checktime
augroup END

" Helping nvim detect filetype
let s:additional_ftypes = {
                        \   '*.zsh*': 'zsh',
                        \   '.env.*': 'sh',
                        \   '*.bnf': 'bnf',
                        \   '*.webmanifest': 'json',
                        \   '*.http': 'rest',
                        \ }

augroup file_types
  autocmd!
  for kv in items(s:additional_ftypes)
    execute 'autocmd BufNewFile,BufRead' kv[0] 'setlocal filetype=' . kv[1]
  endfor

  " Tab configuration for different languages
  autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType java setlocal shiftwidth=4 tabstop=4 expandtab

  autocmd FileType markdown setlocal conceallevel=2
  autocmd FileType *.tsx setlocal filetype=typescript.tsx
  autocmd FileType python setlocal foldmethod=indent

  " JSON5's comment
  autocmd FileType json
                   \ syntax region Comment start="//" end="$" |
                   \ syntax region Comment start="/\*" end="\*/" |
                   \ setlocal commentstring=//\ %s

augroup END

" List of buf names where q does :q<CR>
let s:q_closes_windows = 'help list git'
let s:disable_line_numbers = 'nerdtree help list'

augroup q_close
  for wname in split(s:q_closes_windows)
    execute 'autocmd FileType' wname 'noremap <silent><buffer> q :q<CR>'
  endfor
augroup END

"------------------------- Line numbers configuration -------------------------"
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

"---------------------------------- Mappings ----------------------------------"
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
nnoremap <silent> <Leader>cfg 
                  \ :e ~/.config/nvim/init.vim <Bar>
                  \ :e ~/.config/nvim/lua/init.lua<CR>
nnoremap <silent> <Leader>h :setlocal hlsearch!<CR>
nnoremap <silent> <Leader>w :wall<CR>

function RevStr(str)
  let l:chars = split(submatch(0), '\zs')
  return join(reverse(l:chars), '')
endfunction
vnoremap <Leader>rev :s/\%V.\+\%V./\=RevStr(submatch(0))<CR>gv

"----------------------------- Buffer operations ------------------------------"
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

function! s:DelToLeft()
  silent execute 'bdelete' join(range(1, bufnr() - 1))
endfunction

nnoremap <silent> <Leader>d :call <SID>DelBuf(0)<CR>
nnoremap <silent> <Leader>ad :call <SID>DelBuf(1)<CR>
nnoremap <silent> <Leader>od :call <SID>DelAllExcept()<CR>
nnoremap <silent> <Leader>ld :call <SID>DelToLeft()<CR>

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

nnoremap <Leader>o o<Esc>
nnoremap <Leader><S-O> O<Esc>
" iabbrev </ 

"----------------------------- coc configuration ------------------------------"
let g:coc_global_extensions = [
                            \   'coc-emmet',
                            \   'coc-snippets',
                            \   'coc-svelte',
                            \   'coc-json',
                            \   'coc-highlight',
                            \ ]

let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

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

augroup formatprgs
  autocmd!
  autocmd FileType haskell setlocal formatprg=brittany
  autocmd FileType typescript,typescriptreact
                 \ setlocal formatprg=prettier\ --parser\ typescript
  autocmd FileType javascript,javascriptreact
                 \ setlocal formatprg=prettier\ --parser\ babel
augroup END

function! s:FormatCode()
  if empty(&formatprg)
    call CocActionAsync('format')
  else
    let l:v = winsaveview()
    normal gggqG
    call winrestview(l:v)
  endif
endfunction

"---------------------- COC actions & completion helpers ----------------------"
inoremap <silent><expr> <Tab> <SID>CocTab()
inoremap <silent><expr> <S-Tab> <SID>CocShiftTab()
inoremap <silent><expr> <C-Space> <SID>ExpandCompletion()
inoremap <silent><expr> <CR> <SID>SelectCompletion()

" imap <silent> <C-Space> <Plug>(completion_trigger)
" imap <expr> <Tab> pumvisible() ? "\<Plug>(completion_smart_tab)" : "\<Tab>"
" imap <expr> <S-Tab> pumvisible() ? "\<Plug>(completion_smart_s_tab)" : "\<Tab>"

nnoremap <silent> <Leader>ah :call CocAction('doHover')<CR>
nnoremap <silent> <Leader>aj :call CocAction('jumpDefinition')<CR>
nnoremap <silent> <C-LeftMouse> :call CocAction('jumpDefinition')<CR>
nnoremap <silent> <F2> :call CocActionAsync('rename')<CR>
nnoremap <silent> <Leader>f :call <SID>FormatCode()<CR>

"----------------------------- Embedded terminal ------------------------------"
nnoremap <Leader>` :10split <Bar> :terminal<CR>

augroup terminal_insert
  autocmd!
  autocmd TermOpen * startinsert
"   autocmd TermClose * wincmd c
augroup END

"------------------------- Misc commands & functions --------------------------"
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
             \   split(system("ls ~/.config/nvim/colors/")) +
             \   split(system("ls /usr/share/nvim/runtime/colors/")),
             \   "v:val[:-5]"
             \ )
  for th in themes
    echo th
    execute 'colorscheme' th
    sleep 200m
  endfor
endfunction

function! PrettyComment(comment, fill_char) abort
  let l:text_len = strlen(getline('.'))
  let l:remain_len = 80 - l:text_len

  let l:l_size = l:remain_len / 2
  let l:r_size = l:remain_len - l:l_size

  let l:result = a:comment .
               \ repeat(a:fill_char, l:l_size - strlen(a:comment) - 1) .
               \ ' ' .
               \ getline('.') .
               \ ' ' .
               \ repeat(a:fill_char, l:r_size - 1)

  call setline('.', l:result)
endfunction

function! Emoji2Unicode() abort
  let l:c = execute('ascii')
  let l:u = substitute(l:c, '[^x]*Hex\s*\([a-f0-9]*\),[^H]*', '\1', 'g')
  let l:u = repeat('0', strlen(l:u) % 4) . l:u
  let @m = substitute(l:u, '\(.\{4\}\)', '\\u\1', 'g')
  execute "normal xi\<C-R>m\<Esc>"
endfunction

nnoremap <Leader>eu :call Emoji2Unicode()<CR>

"--------------------------------- Case-tools ---------------------------------"
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

"--------------------------- NERDTree configuration ---------------------------"
" Preserve netrw to load
let g:loaded_netrwPlugin = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeMouseMode = 2
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeIgnore = ['__pycache__$', '\.git$', '\~$']
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeDirArrowExpandable = ''

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

let s:comment_tool = 'vim-commentary'

if s:comment_tool == 'nerdcommenter'
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " NERDCommenter configuration
  " let NERDSpaceDelims = 1
  " let NERDDefaultAlign = 'start'
  " nnoremap <silent> <C-_> :call NERDComment('n', 'Toggle')<CR>
  " xnoremap <silent> <C-_> :call NERDComment('v', 'Toggle')<CR>gv
  " inoremap <silent> <C-_> <C-O>:call NERDComment('i', 'Toggle')<CR>
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

elseif s:comment_tool == 'vim-commentary'

"------------------------ vim-commentary configuration ------------------------"
  function! s:VComment()
    return mode() ==# 'v' ? 'Scgv' : ":Commentary\<CR>gv"
  endfunction

  autocmd FileType typescriptreact setlocal commentstring=//\ %s

  nnoremap <silent> <C-_> :Commentary<CR>
  inoremap <silent> <C-_> <C-O>:Commentary<CR>
  xmap <expr><silent> <C-_> <SID>VComment()
endif

"----------------------------- FZF configuration ------------------------------"
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --ignore"
nnoremap <C-P> :Files<CR>
nnoremap <Leader>rg :Rg<CR>
nnoremap <Leader>b :Buffers<CR>

"-------------------------------- Git bindings --------------------------------"
nnoremap <silent> <Leader>gm :Gdiffsplit!<CR>
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <Leader>gp :10split <Bar> :terminal git push origin HEAD<CR>
nnoremap <silent> <Leader>m[ :diffget //2<CR>
nnoremap <silent> <Leader>m] :diffget //3<CR>

" augroup coc_highlight
"   autocmd!
"   autocmd CursorHold * if exists('g:did_coc_loaded') |
"                      \   silent call CocActionAsync('highlight') |
"                      \ endif
" augroup END

"-------------------------------- Git gutter ----------------------------------"
let g:gitgutter_sign_added = '▕'
let g:gitgutter_sign_modified = '▕'
let g:gitgutter_sign_removed = '▕'

"------------------------------- Neovide stuff --------------------------------"
let g:neovide_fullscreen=v:true
