" Vim syntax file
" Language: sway config file
" Maintainer: kraftwerk28
" Version: 0.1
" Last Change: 2022 Jan 15

finish
if exists("b:current_syntax")
  finish
endif

syntax include @Shell syntax/sh.vim
unlet b:current_syntax

scriptencoding utf-8

syn match swayLineCont /\\$/ contained
syn match swayComment /#.*$/
syn match swayNumber /\v<-?\d+(.\d+)?>/ contained
syn match swayColor /\v#%([0-9a-fA-F]{8}|[0-9a-fA-F]{6})/ contained
syn match swayVariable /\$\k\+/ contained
" syn keyword swayCfgBindsym bindsym nextgroup=sway

" syn region swayStmt
"       \ matchgroup=Define start=/^\s*[a-z_\.]\+/
"       \ end=/$/
"       \ contains=swayLineCont,swayString,swayNumber,swayVariable,swayBlock

" syn keyword swaySet set nextgroup=swayVariable skipwhite

syn match swayExec /exec\(_always\)\?\>/ nextgroup=@Shell skipwhite
" syn region swayExec
"       \ matchgroup=Define start=/exec\|exec_always/
"       \ end=/$/
"       \ contains=swayLineCont,swayString,@Shelll

" String literal
syn region swayString
      \ start=/"/ skip=/\\"/ end=/"/
      \ contains=swayColor,swayVariable contained
syn region swayString
      \ start=/'/ skip=/\\'/ end=/'/
      \ contains=swayColor,swayVariable contained

" syn region swayBlock start=/{/ end=/}/ contained

hi def link swayComment Comment
hi def link swayVariable Statement
hi def link swayString String
hi def link swayNumber Float
hi def link swayColor Identifier
hi def link swayBlock Error
hi def link swayExec Special

let b:current_syntax = "sway"
