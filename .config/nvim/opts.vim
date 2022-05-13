set hidden
set noexpandtab
set softtabstop=0
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set list
" set listchars=tab:»\ ,trail:·
set listchars=tab:>\ ,trail:·
" set listchars=tab:⇥\ ,trail:·
" set listchars=tab:\ ﲒ,trail:·
set cursorline
set colorcolumn=80,120
set mouse=a
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch
set nohlsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=full
set signcolumn=yes
set autoread
set autowrite
set autowriteall
set foldlevel=99
set foldmethod=indent
" set foldexpr = "nvim_treesitter#foldexpr()"
" set foldmethod=expr
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set exrc
set secure

set guicursor=a:blinkon1-Cursor
" set guicursor=a:blinkon1,n-c-sm:block,i-ci-ve:ver25,r-cr-o-v:hor20

set splitbelow splitright
set regexpengine=0
set lazyredraw
" set noshowmode
set undofile
set backupcopy=yes
set inccommand=nosplit
set title

" set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

set shortmess+=c
set diffopt+=vertical

if has("win64")
  set shell=powershell.exe
  set shellquote = ""
  set shellpipe=\|
  set shellxquote=
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellredir=\|\ Out-File\ -Encoding\ UTF8
endif
