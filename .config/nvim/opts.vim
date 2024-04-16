" NOTE: this file must remain in vimL, as it is sourced by Ideavim which
" doesn't support lua
set termguicolors
set hidden
set noexpandtab
set softtabstop=0 tabstop=4 shiftwidth=0
set autoindent
set list

" let &listchars = "tab:  ,trail:·"
" let &listchars = 'tab:> ,trail:·'

" Requires Nerd Font
" let &listchars = 'tab:\uf178 ,trail:·'
" let &listchars = 'tab:\u00bb ,trail:·'
let &listchars = 'tab:» ,trail:·'

set nocursorline nocursorcolumn
set mouse=a mousemodel=extend
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu wildmode=full
set signcolumn=yes
set autoread autowriteall
set foldmethod=indent
set foldlevel=99
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldignore=
" let &foldtext = 'v:lua.vim.treesitter.foldtext()'
set secure
set splitbelow splitright
set regexpengine=0
set lazyredraw
set undofile
set inccommand=nosplit
set title
set shortmess+=c
set diffopt+=vertical
set scrolloff=0
set exrc
set keywordprg=
set jumpoptions+=view

" These are set solely for which-key.nvim plugin to work properly
set timeout
set timeoutlen=250

set writebackup " Enable backup feature
set nobackup " Delete backup file after saving
set backupcopy=yes " Copy & write to current, instead of renaming

" highlight! Cursor gui=reverse guifg=NONE guibg=NONE
" highlight Cursor gui=NONE guifg=bg guibg=fg
" set guicursor=a:blinkon1-Cursor
set guicursor=a:blinkon1-Cursor,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" qwertyuiop[]\asdfghjkl;'zxcvbnm,.
" йцукенгшщзхїґфівапролджєячсмитьбю
" ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ
" QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>
let &langmap = 'йцукенгшщзхїґфівапролджєячсмитьбю;qwertyuiop[]\\asdfghjkl\;''zxcvbnm\,.,ЙЦУКЕНГШЩЗХЇҐФІВАПРОЛДЖЄЯЧСМИТЬБЮ;QWERTYUIOP{}\|ASDFGHJKL:\"ZXCVBNM<>'
