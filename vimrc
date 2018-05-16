" ===== PLUGINS =====
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" make `.` work with tpope's plugins
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-surround'

" comment stuff out with gcc, gc etc.
Plug 'tpope/vim-commentary'

" increment/decrement dates/times etc, same as normal numbers
Plug 'tpope/vim-speeddating'

" git wrapper
Plug 'tpope/vim-fugitive'

" heuristically set tab options
Plug 'tpope/vim-sleuth'

" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'

" fzf fuzzyfinder
Plug '/usr/local/opt/fzf'

" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'

" highlight text outside of textwidth
Plug 'whatyouhide/vim-lengthmatters'

Plug 'vim-scripts/YankRing.vim'

call plug#end()



" ===== SETTINGS =====
" nvim-compatibility for vim
if !has('nvim')
	source ~/.vim/non-nvim.vim
endif

set number

set mouse=a

" enable with :set list
set listchars=eol:¬,precedes:←,extends:→,tab:▶\

" shows symbol on line wrap
set showbreak=↪

set scrolloff=4
set sidescrolloff=5

set textwidth=80

" folding
set foldmethod=syntax
set nofoldenable

" do not redraw during macro execution
set lazyredraw

" break line at specific chars
set linebreak

set shiftround

if has('persistent_undo')
  set undodir=~/.vim-undo/
  set undofile
endif

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*



" ===== KEY MAPPINGS =====
" set leaders
let mapleader = ","
let maplocalleader = "\\"

" alt-ß (neo-layout) / ſ to esc
noremap <silent> ſ <Esc>:nohlsearch<CR>
noremap! ſ <Esc>

" Y works like D (yank up to end of line)
noremap Y y$

" make
map <leader>m :make<CR>

" make current file's directory default for window (shift-alt-d in neo)
nmap δ :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>
nmap <leader>t :FZF<CR>

" decrement/increment number under cursor
noremap + <c-a>
noremap - <c-x>

" add execution environment comment to top of file
nnoremap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" convert current file to unix executable
nnoremap <leader>o :!chmod +x %:S<CR>l
" select pasted text
nnoremap <leader>s V`]
" horizontal split
nnoremap <leader>h :split<CR><C-w>j
" vertical split
nnoremap <leader>v :vsplit<CR><C-w>l



" ===== CONFIG VARS =====
call lengthmatters#highlight('ctermbg=7')

let g:yankring_persist = 0
