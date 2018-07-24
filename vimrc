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

" yank history
Plug 'vim-scripts/YankRing.vim'

" directory tree sidebar
Plug 'scrooloose/nerdtree'

Plug 'scrooloose/syntastic'

if has('nvim')

  Plug 'icymind/NeoSolarized'

  " language server protocol client
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  " autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

endif

call plug#end()


" ===== SETTINGS =====
" nvim-compatibility for vim
if has('nvim')
  colorscheme NeoSolarized
else
  source ~/.vim/non-nvim.vim
endif

set number

set ignorecase
set smartcase

" allow cursor movements to empty fields for block selection
set virtualedit=block

set mouse=a

" allows hidden buffers, needed for LanguageClient
set hidden

" enable with :set list
set listchars=eol:¬,precedes:←,extends:→,tab:▶\

" shows symbol on line wrap
set showbreak=↪

set scrolloff=4
set sidescrolloff=5

set textwidth=80

set tabstop=4

" folding
set foldmethod=syntax
set nofoldenable

" do not redraw during macro execution
set lazyredraw

" break line at specific chars
set linebreak

" round indentation to nearest multiple of shiftwidth
set shiftround

if has('persistent_undo')
  set undodir=~/.vim-undo/
  set undofile
endif

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*

" save on losing focus
autocmd FocusLost,Tableave,BufLeave * :call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction


" ===== KEY MAPPINGS =====
" set leaders
let mapleader = ","
let maplocalleader = "\\"

" alt-ß (neo-layout) / ſ to esc
map <silent> ſ <Esc>:nohlsearch<CR>
map! ſ <Esc>

" Y works like D (yank up to end of line)
map Y y$

" tab switching
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabnew<CR>

" directory tree sidebar
nmap <leader>d :NERDTreeToggle<CR>

" make
map <leader>m :make<CR>

" make current file's directory default for window (shift-alt-d in neo)
nmap δ :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

" decrement/increment number under cursor
noremap + <c-a>
noremap - <c-x>

" split navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" add execution environment comment to top of file
nmap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" convert current file to unix executable
nmap <leader>o :!chmod +x %:S<CR>l
" select pasted text
nmap <leader>s V`]
" horizontal split
nmap <leader>h :split<CR><C-w>j
" vertical split
nmap <leader>v :vsplit<CR><C-w>l

" spell correction
nmap <LocalLeader>de :setlocal spell spelllang=de_20<CR>
nmap <LocalLeader>nl :setlocal spell spelllang=nl_nl<CR>
nmap <LocalLeader>eo :setlocal spell spelllang=eo_l3<CR>
nmap <LocalLeader>en :setlocal spell spelllang=en<CR>
nmap <LocalLeader>gb :setlocal spell spelllang=en_gb<CR>
nmap <LocalLeader>uk :setlocal spell spelllang=en_gb<CR>
nmap <LocalLeader>us :setlocal spell spelllang=en_us<CR>



" ===== CONFIG VARS =====
call lengthmatters#highlight('ctermbg=7')

let g:yankring_persist = 0

let NERDTreeQuitOnOpen = 1
let NERDTreeBookmarksFile = '$HOME/vim/NERDTreeBookmarks'

if has('nvim')
  let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ }

  let g:LanguageClient_autoStart = 1

  let g:deoplete#enable_at_startup = 1

  call deoplete#custom#option({
    \ 'auto_complete': v:false,
    \ 'smart_case': v:true,
    \ })

  " use <C-s> for deoplete autocomplete
  set completeopt-=preview
  inoremap <silent><expr> <C-s>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#mappings#manual_complete()
endif
