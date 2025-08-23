" NOTE: since I might use these options in IdeaVim, which only understands
" .vim files, I won't rewrite it in Lua

set background=light

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
" set winborder=single

" " Dynamic cursor
" set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon500-blinkoff500-TermCursor

" Block cursor for all modes
set guicursor=a:block-blinkon200-blinkoff200-Cursor

" qwertyuiop[]\asdfghjkl;'zxcvbnm,.
" йцукенгшщзхїґфівапролджєячсмитьбю
" ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ
" QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>
