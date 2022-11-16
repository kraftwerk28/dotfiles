" NOTE: this file must remain in vimL, as it is sourced by Ideavim which
" doesn't support lua
set termguicolors
set background=dark
set hidden
set noexpandtab
set softtabstop=0
set tabstop=4
set shiftwidth=0
set autoindent smartindent
set list
let &listchars = "tab:  ,lead:·,trail:·"
set cursorline
set mouse=a mousemodel=extend
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu
set wildmode=full
set signcolumn=auto
set autoread autowrite autowriteall
set foldlevel=99
set foldmethod=indent
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldignore=
set secure
set splitbelow splitright
set regexpengine=0
set lazyredraw
set undofile
set inccommand=nosplit
set title
set shortmess+=c
set diffopt+=vertical
set scrolloff=3
set nobackup backupcopy=yes writebackup
set keywordprg=

" highlight! Cursor gui=reverse guifg=NONE guibg=NONE
" highlight Cursor gui=NONE guifg=bg guibg=fg
" set guicursor=a:blinkon1-Cursor
set guicursor=a:blinkon1-Cursor,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" qwertyuiop[]\asdfghjkl;'zxcvbnm,.
" йцукенгшщзхїґфівапролджєячсмитьбю
" ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ
" QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>
let &langmap = 'йцукенгшщзхїґфівапролджєячсмитьбю;qwertyuiop[]\\asdfghjkl\;''zxcvbnm\,.,ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ;QWERTYUIOP{}\|ASDFGHJKL:\"ZXCVBNM<>'
" set langmap=ФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
