" NOTE: keep this file in vimL, not Lua, because it may be used in IdeaVim

set termguicolors
set hidden
set noexpandtab softtabstop=0 tabstop=4 shiftwidth=0
set autoindent
set list
let &listchars = 'tab:⇥ ,trail:·'
set cursorline nocursorcolumn
set mouse=a mousemodel=extend
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu wildmode=full
set signcolumn=yes
set autoread autowriteall
set foldmethod=indent foldlevel=99 foldopen=hor,mark,percent,quickfix,search,tag,undo foldignore=
set secure
set splitbelow splitright
set regexpengine=0
set undofile
set inccommand=nosplit
set title
set shortmess+=c
set diffopt+=vertical
set scrolloff=0
set exrc
set keywordprg=
set jumpoptions+=view
set timeout timeoutlen=250
set writebackup nobackup backupcopy=yes
set wrap

" set guicursor=a:blinkon500-Cursor,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set guicursor=a:block-blinkon500-Cursor

" qwertyuiop[]\asdfghjkl;'zxcvbnm,.
" йцукенгшщзхїґфівапролджєячсмитьбю
" ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ
" QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>
let &langmap = 'йцукенгшщзхїґфівапролджєячсмитьбю;qwertyuiop[]\\asdfghjkl\;''zxcvbnm\,.,ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ;QWERTYUIOP{}\|ASDFGHJKL:\"ZXCVBNM<>'
