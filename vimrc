" ===== WORK SETUP? =====
let g:at_work = isdirectory('/google') && !has('macunix')

" ===== PLUGINS =====
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" === Editing ===
" make `.` work with tpope's plugins
Plug 'tpope/vim-repeat'
" surround words and other units with parens, quotes etc.
Plug 'tpope/vim-surround'
" comment stuff out with gcc, gc etc.
Plug 'tpope/vim-commentary'
" increment/decrement dates/times etc, same as normal numbers
Plug 'tpope/vim-speeddating'
" tree structure for undo/redo operations
Plug 'mbbill/undotree'

" === Highlighting ===
" highlight text outside of textwidth
Plug 'whatyouhide/vim-lengthmatters'
" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'

" === Integration ===
" git wrapper
Plug 'tpope/vim-fugitive'
" mercurial wrapper
Plug 'ludovicchabant/vim-lawrencium'
" fix tmux focus integration
Plug 'tmux-plugins/vim-tmux-focus-events'
" tmux split navigation
Plug 'christoomey/vim-tmux-navigator'
" fzf fuzzyfinder
Plug 'junegunn/fzf'

" === Optics ===
" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('nvim')
  " solarized theme
  Plug 'icymind/NeoSolarized'
endif

" === Language-specific ===
if has('nvim')
" language server
  Plug 'neovim/nvim-lspconfig'
  " async autocomplete
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
endif
" auto-add end statements of indented code blocks
" Plug 'tpope/vim-endwise'

" === Other ===
" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'
" todo manager
" Plug 'davidoc/taskpaper.vim'

call plug#end()


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

" make
map <leader>m :make<CR>

" make current file's directory default for window (shift-alt-d in neo)
nmap δ :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

" decrement/increment number under cursor
nmap + <c-a>
nmap - <c-x>

" re-select after indenting selection
vnoremap < <gv
vnoremap > >gv

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


" ===== SETTINGS =====
" nvim-compatibility for vim
if has('nvim')
  colorscheme NeoSolarized
else
  source ~/.vim/non-nvim.vim
endif

" work-specific tooling
if g:at_work
  source $HOME/.vim/work.vim
endif

set number

set ignorecase
set smartcase

" allow cursor movements to empty fields for block selection
set virtualedit=block

set mouse=a

" enable with :set list
set listchars=eol:¬,precedes:←,extends:→,tab:▶\

" shows symbol on line wrap
set showbreak=↪

set breakindent
set breakindentopt=shift:4

set scrolloff=4
set sidescrolloff=5

set textwidth=80

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=-1

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

set noswapfile

set completeopt=

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
if g:at_work
  function! MaybeFormatCode()
    if expand("%:t") != 'lvs.borg' && !&diff
      FormatCode
    endif
  endfunction
  autocmd BufWritePre /google/* call MaybeFormatCode()
endif

" check for external changes on gaining focus
autocmd FocusGained,BufEnter * :checktime


" ===== LANGUAGE SERVER CONFIG =====
if has('nvim')
  let g:coq_settings = {
              \ 'display.icons.mode': 'none',
              \ 'completion.always': v:false,
              \ }

  if g:at_work
    luafile $HOME/.vim/lsp/coq_ciderlsp.lua
  else
    " TODO Configure language servers / linters for home use
  endif
endif


" ===== PLUGIN CONFIG =====

call lengthmatters#highlight_link_to('FoldColumn')

let g:task_paper_search_hide_done = 1

" airline statusline
" don't display file encoding and file format if it is the expected value
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
" slightly change looks of line count section
let g:airline_section_z =
      \ '%3p%% ' .
      \ '%{g:airline_symbols.linenr}%4l%#__accent_bold#/%L%#__restore__# :%3v'
let g:airline#extensions#tagbar#enabled = 0
