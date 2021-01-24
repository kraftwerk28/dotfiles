set encoding=utf-8
set termguicolors
set background=dark

lua init = require 'init'
lua init.setup()

"---------------------------------- Theme -------------------------------------"
" if $XDG_CURRENT_DESKTOP == 'GNOME' &&
" \  !(system('gsettings get org.gnome.desktop.interface gtk-theme') =~# 'dark')
"   set background=light
"   let ayucolor = 'light'
" else
"   set background=dark
"   let ayucolor = 'mirage'
" endif

let g:ayucolor = 'dark'
colorscheme gruvbox

if colors_name == 'onedark'
  let g:onedark_terminal_italics = 1
elseif colors_name == 'gruvbox'
  let g:gruvbox_italic = 1
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_invert_selection = 0
endif

augroup alter_ayu_colorscheme
  autocmd!
  if exists('colors_name') && colors_name == 'ayu'
    autocmd ColorScheme * highlight VertSplit guifg=#FFC44C
  endif
augroup END

"-------------------------------- Lightline -----------------------------------"
let FilenameLabel = {-> luaeval('init.lightline.filename_label()')}
let FiletypeLabel = {-> luaeval('init.lightline.filetype_label()')}
" let LSPWarnings = {-> luaeval('init.lightline.lspwarnings()')}
" let LSPErrors = {-> luaeval('init.lightline.lsperrors()')}

" augroup lsp_on_publish_diagnostics
"   autocmd!
"   autocmd User LSPOnDiagnostics silent! call lightline#update()
" augroup END

let g:left_triangle_filled = "\ue0b8"
let g:left_triangle_sep = "\ue0b9"
let g:right_triangle_filled = "\ue0ba"
let g:right_triangle_sep = "\ue0bb"

if g:colors_name == 'ayu'
  source ~/.config/nvim/lightline_ayu_dark.vim
endif

let g:lightline = {
\   'enable': {'statusline': 1, 'tabline': 1},
\   'active': {
\     'left': [
\       ['mode', 'paste'],
\       ['filename', 'readonly', 'modified'],
\     ],
\     'right': [
\       ['lineinfo'],
\       ['percent'],
\       ['fileencoding', 'filetype'],
\     ],
\   },
\   'component': {
\     'readonly': '%{&readonly ? "\uf023" : ""}',
\     'modified': '%{&modified ? "\uf693" : ""}',
\   },
\   'component_visible_condition': {
\    'readonly': '&readonly',
\    'modified': '&modified',
\   },
\   'component_function': {
\     'filename': 'FilenameLabel',
\     'filetype': 'FiletypeLabel',
\   },
\ }

if g:colors_name == 'ayu'
  let g:lightline.colorscheme = 'ayu_dark_custom'
elseif g:colors_name == 'gruvbox'
  let g:lightline.colorscheme = 'gruvbox'
endif

" Must be AFTER augroup above
syntax on

let g:mapleader = ' '

"--------------------------- Airline configuration ----------------------------"
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_theme = 'ayu_dark'
let g:airline_extensions = ['tabline', 'nvimlsp']
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_left_sep = "\ue0b8"
let g:airline_right_sep = "\ue0ba"

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

"--------------------------- Devicos configuration ----------------------------"
let g:webdevicons_enable_nerdtree = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsDefaultFolderOpenSymbol = "\uf07c"
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol="\uf07b"
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
set expandtab softtabstop=4 tabstop=4 shiftwidth=2
set autoindent smartindent
set list listchars=tab:➔\ ,trail:·,space:·
set ignorecase
set cursorline colorcolumn=80,120
set mouse=a
set clipboard+=unnamedplus
set completeopt=menuone,noinsert,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu wildmode=full
set signcolumn=yes " Additional column on left for emoji signs
set autoread autowrite autowriteall
set foldlevel=99 foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldcolumn=1 " Enable additional column w/ visual folds
set exrc secure " Project-local .nvimrc/.exrc configuration
set scrolloff=3
set diffopt+=vertical
" set guicursor=n-v-c-i-ci:block,o:hor50,r-cr:hor30,sm:block
set splitbelow splitright
set regexpengine=0
set lazyredraw
set guifont=JetBrains\ Mono\ Nerd\ Font:h18
" set shada='1000,%
set noshowmode
set shortmess+=c

"---------------------------------- Autocmd -----------------------------------"
augroup ft_indent
  autocmd!
  autocmd FileType go,make setlocal shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType python,java,csharp
                 \ setlocal sw=4 sts=4 et
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,svelte,vim
                 \ setlocal sw=2 sts=2 et
  autocmd FileType lua setlocal sw=2 sts=2 et
augroup END

function! s:RestoreCursor()
  echom 'Restoring cursor'
  let l:last_pos = line("'\"")
  if l:last_pos > 0 && l:last_pos <= line('$')
    exe 'normal! g`"'
  endif
endfunction
augroup restore_cursor
  autocmd!
  autocmd BufReadPost * call s:RestoreCursor()
augroup END

augroup auto_save
  autocmd!
  autocmd FocusLost * silent! wall
augroup END

" Reload file if it changed on disk
augroup auchecktime
  autocmd!
  autocmd BufEnter,FocusGained * silent! checktime
augroup END

" Helping nvim detect filetype
let s:additional_filetypes = {
\   'zsh': '*.zsh*',
\   'sh': '.env.*',
\   'bnf': '*.bnf',
\   'json': '*.webmanifest',
\   'rest': '*.http',
\   'elixir': ['*.exs', '*.ex'],
\ }

augroup file_types
  autocmd!
  for kv in items(s:additional_filetypes)
    if type(kv[1]) == v:t_list
      for ext in kv[1]
        execute 'autocmd BufNewFile,BufRead ' . ext
              \ . ' setlocal filetype=' . kv[0]
      endfor
    else
      execute 'autocmd BufNewFile,BufRead ' . kv[1]
            \ . ' setlocal filetype=' . kv[0]
    endif
  endfor

  autocmd FileType markdown setlocal conceallevel=2

  " json 5 comment
  autocmd FileType json
                 \ syntax region Comment start="//" end="$" |
                 \ syntax region Comment start="/\*" end="\*/" |
                 \ setlocal commentstring=//\ %s
augroup END

" Filetypes names where q does :q<CR>
let g:q_close_ft = ['help', 'list', 'fugitive']
let g:disable_line_numbers = [
\   'nerdtree', 'NvimTree', 'help',
\   'list', 'clap_input', 'TelescopePrompt',
\ ]

augroup aux_win_close
  autocmd!

  autocmd FileType fugitive map <buffer> <Esc> gq

  for _ft in g:q_close_ft
    execute 'autocmd FileType' _ft 'noremap <silent><buffer> q :q<CR>'
  endfor
augroup END

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua init.yank_highlight()
augroup END

"------------------------- Line numbers configuration -------------------------"
function! s:SetNumber(set)
  if empty(&filetype) || index(g:disable_line_numbers, &filetype) > -1
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

"----------------------------- Mapping functions ------------------------------"
function RevStr(str)
  let l:chars = split(submatch(0), '\zs')
  return join(reverse(l:chars), '')
endfunction

"----------------------------- Buffer operations ------------------------------"
function! s:buf_filt(inc_cur)
  function! s:filt_fn(include_current, idx, val)
    if !bufexists(a:val) ||
     \ !buflisted(a:val) ||
     \ buffer_name(a:val) =~? 'NERD_tree_*' ||
     \ (a:include_current && bufnr() == a:val)
      return v:false
    endif
    return v:true
  endfunction
  return filter(range(1, bufnr('$')), function('s:filt_fn', [a:inc_cur]))
endfunction

function! s:DellAllBuf()
  wall
  silent execute 'bdelete ' . join(s:buf_filt(0))
endfunction

function! s:DellThisBuf()
  update
  bprevious | split | bnext | bdelete
endfunction

" Delete buffers except current
function! s:DelAllExcept()
  wall
  silent execute 'bdelete' join(s:buf_filt(1))
endfunction

" TODO
function! s:DelToLeft()
  silent execute 'bdelete' join(range(1, bufnr() - 1))
endfunction

" Prettier bindings
function! s:RunPrettier()
  execute 'silent !prettier --write %'
  edit
endfunction

"----------------------------- CoC configuration ------------------------------"
let g:coc_global_extensions = [
\   'coc-emmet',
\   'coc-svelte',
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

function! s:CompletionTab()
  return pumvisible() ? "\<C-N>" : "\<Tab>"
endfunction

function! s:CompletionShiftTab()
  return pumvisible() ? "\<C-P>" : "\<Tab>"
endfunction

augroup formatprgs
  autocmd!
  autocmd FileType haskell setlocal formatprg=brittany
  autocmd FileType typescript,typescriptreact
                 \ setlocal formatprg=prettier\ --parser\ typescript
  autocmd FileType javascript,javascriptreact
                 \ setlocal formatprg=prettier\ --parser\ babel
  autocmd FileType cabal setlocal formatprg=cabal-fmt
  autocmd FileType lua setlocal formatprg=lua-format\ -c\ ~/.lua-format
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

augroup completion_nvim
  autocmd!
  function! s:OnAttachLSP()
    if index(['clap_input'], &filetype) == -1
      lua require'completion'.on_attach()
    endif
  endfunction
  " autocmd BufEnter * call s:OnAttachLSP()
augroup END

augroup lsp_diagnostics
  autocmd!
  autocmd CursorMoved * lua init.show_lsp_diagnostics()
augroup END

"------------------------------- builtin LSP ----------------------------------"
highlight LSPCurlyUnderline gui=undercurl
highlight LSPUnderline gui=underline
highlight! link LspDiagnosticsUnderlineHint LSPCurlyUnderline
highlight! link LspDiagnosticsUnderlineInformation LSPCurlyUnderline
highlight! link LspDiagnosticsUnderlineWarning LSPCurlyUnderline
highlight! link LspDiagnosticsUnderlineError LSPUnderline
highlight! LspDiagnosticsSignHint guifg=yellow
highlight! LspDiagnosticsSignInformation guifg=lightblue
highlight! LspDiagnosticsSignWarnint guifg=yellow
highlight! LspDiagnosticsSignError guifg=red

call sign_define('LspDiagnosticsSignHint', {
\   'text': "\uf0eb",
\   'texthl': 'LspDiagnosticsSignHint',
\ })
call sign_define('LspDiagnosticsSignInformation', {
\   'text': "\uf129",
\   'texthl': 'LspDiagnosticsSignInformation',
\ })
call sign_define('LspDiagnosticsSignWarning', {
\   'text': "\uf071",
\   'texthl': 'LspDiagnosticsSignWarning',
\ })
call sign_define('LspDiagnosticsSignError', {
\   'text': "\uf06a",
\   'texthl': 'LspDiagnosticsSignError',
\ })

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_timer_cycle = 500

let g:UltiSnipsExpandTrigger = "<nop>"
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = {
\   'default' : [
\     {'complete_items': ['lsp', 'path']},
\     {'complete_items': ['snippet', 'buffers']},
\   ]
\ }

"----------------------------- Embedded terminal ------------------------------"
augroup terminal_insert
  autocmd!
  autocmd TermOpen * startinsert
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

"--------------------------- NvimTree configuration ---------------------------"
highlight link NvimTreeFolderName Directory 
highlight link NvimTreeFolderIcon Tag

let g:nvim_tree_icons = {
\   'folder': {
\     'default': "\uf07b",
\     'open': "\uf07c",
\     'symlink': "\uf0c1",
\   },
\ }
let g:nvim_tree_auto_close = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_indent_markers = 1

"------------------------- Comment tool configuration -------------------------"
function! s:VComment()
  return mode() ==# 'v' ? 'Scgv' : ":Commentary\<CR>gv"
endfunction
autocmd FileType typescriptreact setlocal commentstring=//\ %s

"-------------------------- Vim-clap configuration ----------------------------"
let g:clap_insert_mode_only = v:true
let g:clap_search_box_border_style = 'nil'

let g:clap_selected_sign = {
\   'text': "\uf00c",
\   'texthl': 'ClapSelectedSign',
\   'linehl': 'ClapSelected',
\ }
let g:clap_current_selection_sign = {
\   'text': "\uf061",
\   'texthl': 'ClapCurrentSelectionSign',
\   'linehl': 'ClapCurrentSelection',
\ }
let g:clap_no_matches_msg = 'Bruh...'
let g:clap_layout = { 'relative': 'editor', 'row': 4 }

"-------------------------------- Git bindings --------------------------------"
augroup LSP_highlight
  autocmd!
  autocmd CursorHold <buffer> silent! lua vim.lsp.buf.document_highlight()
  autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight()
  " autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END

function! PasteBlock()
  execute 'normal!' repeat("O\<Esc>", len(split(@", '\n')))
  normal! p
endfunction

"-------------------------------- Git gutter ----------------------------------"
let g:gitgutter_sign_added = '▕'
let g:gitgutter_sign_modified = '▕'
let g:gitgutter_sign_removed = '▕'

"------------------------------- Neovide stuff --------------------------------"
let g:neovide_fullscreen=v:true


"--------------------------------- Mappings -----------------------------------"
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

" Buffer nav
nnoremap <silent> <M-]> :bnext<CR>
nnoremap <silent> <M-[> :bprevious<CR>
nnoremap <silent> <Leader>d :call <SID>DellThisBuf()<CR>
nnoremap <silent> <Leader>ad :call <SID>DellAllBuf()<CR>
nnoremap <silent> <Leader>od :call <SID>DelAllExcept()<CR>
nnoremap <silent> <Leader>ld :call <SID>DelToLeft()<CR>

" Tab nav
nnoremap th :tabprevious<CR>
nnoremap tl :tabnext<CR>
nnoremap tj :tablast<CR>
nnoremap tk :tabfirst<CR>
nnoremap th :tabnext<CR>
nnoremap tt :tabnew<CR>
nnoremap td :tabclose<CR>

nnoremap <silent> <Leader>src :w<CR> :source ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>cfg 
                  \ :e ~/.config/nvim/lua/init.lua <Bar>
                  \ :e ~/.config/nvim/init.vim <CR>
nnoremap <silent> <Leader>h :setlocal hlsearch!<CR>
nnoremap <silent> <Leader>w :wall<CR>

" LSP mappings:
if exists('g:coc_enabled') && g:coc_enabled
  inoremap <silent><expr> <Tab> <SID>CompletionTab()
  inoremap <silent><expr> <S-Tab> <SID>CompletionShiftTab()
  inoremap <silent><expr> <C-Space> <SID>ExpandCompletion()
  inoremap <silent><expr> <CR> <SID>SelectCompletion()
  nnoremap <silent> <Leader>ah :call CocAction('doHover')<CR>
  nnoremap <silent> <Leader>aj :call CocAction('jumpDefinition')<CR>
  nnoremap <silent> <C-LeftMouse> :call CocAction('jumpDefinition')<CR>
  nnoremap <silent> <F2> :call CocActionAsync('rename')<CR>
  nnoremap <silent> <Leader>f :call <SID>FormatCode()<CR>
else
  imap <Tab> <Plug>(completion_smart_tab)
  imap <S-Tab> <Plug>(completion_smart_s_tab)
  imap <M-J> <Plug>(completion_next_source)
  imap <M-K> <Plug>(completion_prev_source)
  imap <silent> <C-Space> <Plug>(completion_trigger)
  nnoremap <silent> <Leader>f :lua init.format_code()<CR>
  nnoremap <silent> <Leader>ah :lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <Leader>aj :lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <Leader>ae
                  \ :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nnoremap <silent> <Leader>aa :lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
endif

vnoremap <Leader>rev :s/\%V.\+\%V./\=RevStr(submatch(0))<CR>gv

nnoremap <Leader>eu :call Emoji2Unicode()<CR>

" Case-conversion tools
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

nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+1<CR>
vnoremap <silent> <M-k> :m'<-2<CR>gv
vnoremap <silent> <M-j> :m'>+1<CR>gv

vnoremap <Leader>rv :s/\%V

nnoremap <Leader>o o<Esc>
nnoremap <Leader><S-O> O<Esc>

nnoremap <Leader>` :10split <Bar> :terminal<CR>

" Commenting
nnoremap <silent> <C-_> :Commentary<CR>
inoremap <silent> <C-_> <C-O>:Commentary<CR>
xmap <expr><silent> <C-_> <SID>VComment()

" File explorer
nnoremap <silent> <F3> :NvimTreeToggle<CR>
nnoremap <silent> <Leader><F3> :NvimTreeFindFile<CR>

" Search tool
nnoremap <C-P> :Telescope find_files<CR>
nnoremap <Leader>rg :Telescope live_grep<CR>
nnoremap <Leader>b :Telescope buffers<CR>
nnoremap <C-B> :Telescope buffers<CR>

" Git
nnoremap <silent> <Leader>gm :Gdiffsplit!<CR>
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <Leader>gp :10split <Bar> :terminal git push origin HEAD<CR>
nnoremap <silent> <Leader>m[ :diffget //2<CR>
nnoremap <silent> <Leader>m] :diffget //3<CR>

map Q <Nop>

" vnoremap <Leader>df d"=system('date +"%Y-%m-%d %H:%M:%S" -d @' . @")[:-2]<C-M>P
" for pair in ["h \<Left>", "j \<Down>", "k \<Up>", "l \<Right>"]
"   let s:p = split(pair, ' ')
"   execute 'cnoremap ' . s:p[0] . ' ' . s:p[1]
"   execute 'cnoremap ' . s:p[1] . ' ' . s:p[0]
" endfor
