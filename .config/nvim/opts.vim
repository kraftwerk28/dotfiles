" NOTE: this file is kept in VimL (instead of rewriting to Lua), since it may
" be used with IdeaVim plugin which (afaik) can only parse a subset of VimL

set background=light
set tabstop=4 shiftwidth=0
set cursorline nocursorcolumn
set mouse=a mousemodel=extend
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set incsearch nohlsearch
set ignorecase smartcase
set wildmenu wildmode=full
set signcolumn=yes
set autoread autowriteall
set splitbelow splitright
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
set noshowmode

set list
let &listchars = 'tab:⇥ ,trail:·'

" Folding
set foldlevel=99
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldignore=
set foldmethod=expr
let &foldexpr = 'v:lua.vim.treesitter.foldexpr()'

" " Default
" set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor

" Dynamic cursor
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon500-blinkoff500-TermCursor

" " Block cursor for all modes
" set guicursor=a:block-blinkon200-blinkoff200-Cursor
