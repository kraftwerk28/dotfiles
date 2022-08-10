" NOTE: this file 
set termguicolors
set background=dark
set hidden
set noexpandtab
set softtabstop=0
set tabstop=4
set shiftwidth=4
set autoindent smartindent
set list
let &listchars = 'tab:  ,lead:·,trail:·'
set cursorline
" set colorcolumn=80,120
set mouse=a
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu
set wildmode=full
set signcolumn=yes
set autoread autowrite autowriteall
set foldlevel=99
set foldmethod=indent
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set exrc
set secure
set splitbelow splitright
set regexpengine=0
set lazyredraw
set undofile
set backupcopy=yes
set inccommand=nosplit
set title
set shortmess+=c
set diffopt+=vertical
set scrolloff=3
" highlight! Cursor gui=reverse guifg=NONE guibg=NONE
highlight Cursor gui=NONE guifg=bg guibg=fg
" set guicursor=a:blinkon1-Cursor
set guicursor=a:blinkon1-Cursor,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

if has("win64")
  set shell=powershell.exe
  let shellpipe = '|'
  set shellxquote=
  let &shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  let &shellredir = "| Out-File -Encoding UTF8"
endif
