scriptencoding utf-8
autocmd!
set termguicolors
set background=dark

syntax enable
syntax on

lua init = require('init')

"---------------------------------- Autocmd -----------------------------------"
augroup filetype_options
  autocmd!
  autocmd FileType
        \ go,make,c,cpp,python
        \ setlocal shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType
        \ java,kotlin,groovy,csharp,cabal
        \ setlocal shiftwidth=4 tabstop=4 expandtab
  autocmd FileType
        \ javascript,typescript,javascriptreact,typescriptreact,svelte,json,vim,yaml,haskell,lisp,lua
        \ setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType jess setlocal commentstring=;\ %s
  autocmd FileType json,jsonc,cjson setlocal commentstring=//\ %s
augroup END

function! s:restoreCursor()
  echom 'Restoring cursor'
  let l:last_pos = line("'\"")
  if l:last_pos > 0 && l:last_pos <= line('$')
    exe 'normal! g`"'
  endif
endfunction

autocmd BufReadPost * call s:restoreCursor()

augroup auto_save
  autocmd!
  autocmd FocusLost * silent! wall
augroup END

" Reload file if it changed on disk
autocmd CursorHold,CursorHoldI * if !bufexists('[Command Line]')
                             \ |   silent checktime
                             \ | endif

autocmd FileType markdown setlocal conceallevel=2
autocmd FileType NvimTree setlocal signcolumn=no
autocmd WinEnter * if win_gettype() == 'popup'
               \ |   setlocal conceallevel=3
               \ | endif

" Filetypes names where q does :q<CR>
let g:q_close_ft = ['help', 'list', 'qf']
let g:esc_close_ft = ['NvimTree']

augroup aux_win_close
  autocmd!
  autocmd FileType fugitive,git nmap <buffer> q gq
  execute printf('autocmd FileType %s noremap <silent><buffer> <Esc> :q<CR>',
               \ join(g:esc_close_ft, ','))
  execute printf('autocmd FileType %s noremap <silent><buffer> q :q<CR>',
               \ join(g:q_close_ft, ','))
augroup END

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua init.yank_highlight()
augroup END

" autocmd WinEnter * if &buftype == 'terminal'
"                \ |   startinsert
"                \ | endif

"------------------------- Line numbers configuration -------------------------"
let g:no_line_numbers_ft = ['help', 'list', 'clap_input', 'TelescopePrompt']

function! s:setNumber(alsoRelative)
  if win_gettype() == 'popup' || index(g:no_line_numbers_ft, &filetype) > -1
    return
  endif
  setlocal number
  if a:alsoRelative
    setlocal relativenumber
  else
    setlocal norelativenumber
  endif
endfunction

augroup line_numbers
  autocmd!
  autocmd BufEnter,Winenter,FocusGained * call s:setNumber(1)
  autocmd BufLeave,Winleave,FocusLost * call s:setNumber(0)
augroup END

"----------------------------- Mapping functions ------------------------------"
function RevStr(str)
  let l:chars = split(submatch(0), '\zs')
  return join(reverse(l:chars), '')
endfunction

function! s:compTab()
  if pumvisible()
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

function! s:compShiftTab()
  if pumvisible()
    return "\<C-P>"
  else
    return "\<S-Tab>"
  endif
endfunction

function! s:compEnter()
  if pumvisible() && complete_info()['selected'] != -1
    return compe#confirm()
  else
    return "\<CR>"
  endif
endfunction

function! s:nvimTreeToggle(find)
  if &filetype == 'NvimTree'
    NvimTreeClose
  elseif a:find
    NvimTreeFindFile
  else
    NvimTreeOpen
    let l:found = win_findbuf(bufnr('NvimTree'))
    if len(l:found)
      call win_gotoid(l:found[0])
    endif
  endif
endfunction

augroup formatprgs
  autocmd!
  autocmd FileType haskell setlocal formatprg=brittany
  autocmd FileType
        \ typescript,typescriptreact
        \ setlocal formatprg=prettier\ --parser\ typescript
  autocmd FileType
        \ javascript,javascriptreact
        \ setlocal formatprg=prettier\ --parser\ babel
  autocmd FileType cabal setlocal formatprg=cabal-fmt
augroup END

" autocmd BufEnter * lua require('lsp_signature').on_attach()

augroup lsp_diagnostics
  autocmd!
  autocmd CursorMoved * lua init.show_lsp_diagnostics()
augroup END
autocmd! lsp_diagnostics

augroup LSP_highlight
  autocmd!
  autocmd CursorHold <buffer> silent! lua vim.lsp.buf.document_highlight()
  autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END
autocmd! LSP_highlight

"----------------------------- Embedded terminal ------------------------------"
augroup terminal_insert
  autocmd!
  autocmd TermOpen * startinsert
augroup END

autocmd FocusGained * silent !pwd > /tmp/last_pwd

"------------------------- Misc commands & functions --------------------------"
" Adds shebang to current file and makes it executable (to current user)
let s:filetype_executables = {'javascript': 'node'}

function! s:shebang()
  silent! write
  execute 'silent !chmod u+x %'
  if stridx(getline(1), "#!") == 0
    echo 'Shebang already exists.'
    return
  endif
  execute 'silent !which ' . &filetype
  let l:shb = '#!/usr/bin/env '
  if v:shell_error == 0
    let l:shb .= &filetype
  elseif has_key(s:filetype_executables, &filetype)
    let l:shb .= s:filetype_executables[&filetype]
  else
    echoerr 'Filename not supported.'
    return
  endif
  call append(0, shb)
  update
endfunction

command! -nargs=0 Shebang call s:shebang()

function! Durka()
  let themes = map(
  \   split(system('ls ~/.config/nvim/colors/')) +
  \   split(system('ls /usr/share/nvim/runtime/colors/')),
  \   'v:val[:-5]'
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

command! -nargs=0 LspLog execute 'edit ' . luaeval('vim.lsp.get_log_path()')

" augroup display_signature_help
"   autocmd!
"   autocmd CursorMoved <buffer> lua vim.lsp.buf.signature_help()
" augroup END

function! PasteBlock()
  execute 'normal!' repeat("O\<Esc>", len(split(@", '\n')))
  normal! p
endfunction

" function s:expandFolds()
"   let l:fld = &foldlevel
"   let &foldlevel = 99
"   let &foldlevel = l:fld
" endfunction

"--------------------------------- Mappings -----------------------------------"
" The block below WON'T execute in vscode-vim extension,
" so thath's why I use it
if has("nvim")
  nnoremap <silent> j gj
  nnoremap <silent> k gk
  nnoremap <silent> gj j
  nnoremap <silent> gk k
endif

" Arrow movement mappings
nnoremap <Down> <C-E>
nnoremap <Up> <C-Y>
nnoremap <S-Up> <C-U>M
nnoremap <S-Down> <C-D>M
nnoremap <C-Up> <C-B>M
nnoremap <C-Down> <C-F>M

" Indenting
vnoremap > >gv
vnoremap < <gv

" Buffer nav
nnoremap <silent> <M-]> :bnext<CR>
nnoremap <silent> <M-[> :bprevious<CR>
" nnoremap <silent> <Leader>dbb :lua vim.api.nvim_buf_delete(0, {})<CR>
" nnoremap <silent> <Leader>dba :lua init.delete_bufs(true)<CR>
" nnoremap <silent> <Leader>dbo :lua init.delete_bufs(false)<CR>

" Tab nav
nnoremap <silent> th :tabprevious<CR>
nnoremap <silent> tj :tablast<CR>
nnoremap <silent> tk :tabfirst<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tt :tabnew<CR>
nnoremap <silent> td :tabclose<CR>
nnoremap <silent> tH :-tabmove<CR>
nnoremap <silent> tL :+tabmove<CR>

nnoremap <silent> <Leader>src :w<CR> :source ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>cfg
      \ :e ~/.config/nvim/lua/init.lua <Bar>
      \ :e ~/.config/nvim/init.vim <CR>
nnoremap <silent> <Leader>hs :setlocal hlsearch!<CR>
nnoremap <silent> <Leader>w :wall<CR>

" LSP mappings:
" inoremap <expr> <Tab> <SID>compTab()
" inoremap <expr> <S-Tab> <SID>compShiftTab()
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR> <SID>compEnter()
nnoremap <silent> <Leader>f :lua init.format_code()<CR>
nnoremap <silent> <Leader>ah :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>aj :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>ae :lua init.show_line_diagnostics()<CR>
nnoremap <silent> <Leader>aa :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
inoremap <silent> <C-S> <Cmd>lua vim.lsp.buf.signature_help()<CR>

vnoremap <Leader>rev :s/\%V.\+\%V./\=RevStr(submatch(0))<CR>gv

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
nnoremap <Leader>O O<Esc>

nnoremap <Leader>` :10split <Bar> :terminal<CR>

" Commenting
nmap <silent> <C-_> gcc
imap <silent> <C-_> <C-O>:normal gcc<CR>
xmap <silent> <C-_> gc

" File explorer
nnoremap <silent> <F3> :call <SID>nvimTreeToggle(0)<CR>
nnoremap <silent> <Leader><F3> :call <SID>nvimTreeToggle(1)<CR>

" Search tool
nnoremap <silent> <C-P> :Telescope find_files<CR>
nnoremap <silent> <Leader>rg :Telescope live_grep<CR>
nnoremap <silent> <Leader>b :Telescope buffers<CR>
nnoremap <silent> <C-B> :Telescope buffers<CR>
nnoremap <silent> <Leader>ad :Telescope lsp_workspace_diagnostics<CR>

" Git
nnoremap <silent> <Leader>gm :Gdiffsplit!<CR>
nnoremap <silent> <Leader>gs :vertical Git<CR>
nnoremap <silent> <Leader>gp :Git --paginate push origin HEAD<CR>
nnoremap <silent> <Leader>m[ :diffget //2<CR>
nnoremap <silent> <Leader>m] :diffget //3<CR>

" Autoclose tag
autocmd FileType svg,xml,html inoremap <buffer> </> </<C-X><C-O><C-N>

" tnoremap <Esc> <C-\><C-N>
" Window/tab switch when in terminal-insert
tnoremap <C-W>j <C-\><C-N><C-W>j
tnoremap <C-W>k <C-\><C-N><C-W>k
tnoremap <C-W>l <C-\><C-N><C-W>l
tnoremap th <C-\><C-N>th
tnoremap tl <C-\><C-N>tl
tnoremap <ScrollWheelUp> <C-X><C-Y>
tnoremap <ScrollWheelDown> <C-X><C-E>

nnoremap <silent> <Leader>qj :cnext<CR>
nnoremap <silent> <Leader>qk :cprevious<CR>
nnoremap <silent> <Leader>qc :cprevious<CR>

inoremap <C-H> <C-W>

" let s:pairs = ['{}', '()', '[]']
" function! s:autoPair()
"   let line = getline('.')
"   let col = col('.')
"   let before = line[col - 2:col - 2]
"   let after = line[col - 1:col - 1]
"   for pairStr in s:pairs
"     if pairStr[0] == before &&
"      \ pairStr[1] == after
"       return "\<CR>\<CR>\<Up>\<Esc>cc"
"     endif
"   endfor
"   return "\<CR>"
" endfunction
" for pairStr in s:pairs
"   execute printf("inoremap <expr> %s '%s<\Left>'",
"                \ pairStr[0],
"                \ pairStr)
" endfor
" inoremap <expr> <CR> <SID>autoPair()

" autocmd VimEnter * if isdirectory(expand('%:p'))
"                \ |   cd %:p
"                \ |   bdelete
"                \ | else
"                \ |   cd %:p:h
"                \ | endif

" let g:log_limit = 40
" function TruncLog()
"   let l:path = v:lua.vim.lsp.get_log_path()
"   execute '!echo "$(tail -n '.g:log_limit.' '.l:path.')" > '.l:path
" endfunction
" autocmd VimEnter * call TruncLog()
