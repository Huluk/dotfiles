" ===== KEY MAPS =====

" Maps system:
"
" <leader>
" • anything related to vim itself
" • language-agnostic commands
" • LSP commands which modify the code
" Neo greek layer
" • LSP info
" <localleader>
" • language-specific file actions or commands
"
" Additional maps may be defined in ftplugin/* and the lsp/ config.

" set leaders
let mapleader = ","
let maplocalleader = "\\"

" GENERAL MAPS

" alt-ß (neo-layout) / ſ to esc
map <silent> ſ <Esc>:nohlsearch<CR>
map! ſ <Esc>

" tab switching
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabnew<CR>

" decrement/increment number under cursor
nmap + <c-a>
nmap - <c-x>

" re-select after indenting selection
vnoremap < <gv
vnoremap > >gv

" LEADER MAPS

" make current file's directory default for window
nmap <leader>d :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

" make
nmap <leader>m :make<CR>
" add execution environment comment to top of file
nmap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" make current file unix executable
nmap <leader>o :!chmod +x %:S<CR>l

" select pasted text
nmap <silent> <leader>s V`]

" uppercase previous word
inoremap <c-ü> <Esc>bgU$A

" horizontal split
nmap <leader>h :split<CR><C-w>j
" vertical split
nmap <leader>v :vsplit<CR><C-w>l

" LOCALLEADER MAPS

" spell correction
nmap <localleader>de :setlocal spell spelllang=de_20<CR>
nmap <localleader>nl :setlocal spell spelllang=nl_nl<CR>
nmap <localleader>eo :setlocal spell spelllang=eo_l3<CR>
nmap <localleader>en :setlocal spell spelllang=en<CR>
nmap <localleader>gb :setlocal spell spelllang=en_gb<CR>
nmap <localleader>uk :setlocal spell spelllang=en_gb<CR>
nmap <localleader>us :setlocal spell spelllang=en_us<CR>


" ===== SETTINGS =====
filetype plugin on
filetype plugin indent on

if has('nvim')
  " Global statusline to reduce visual clutter.
  set laststatus=3
else
  " nvim-compatibility for vim
  source ~/.vim/non-nvim.vim
endif

set number
set relativenumber
set cursorline
set signcolumn=number

set ignorecase
set smartcase

" allow cursor movements to empty fields for block selection
set virtualedit=block

set mouse=a

set scrolloff=4
set sidescrolloff=5

" enable with :set list
set listchars=precedes:←,extends:→,eol:¬,nbsp:␣,tab:⊳⋅,trail:⌁

" shows symbol on line wrap
set showbreak=↪

set breakindent
set textwidth=80
" break line at specific chars
set linebreak

set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=-1

" folding
set foldmethod=syntax
set foldminlines=3
set nofoldenable

" round indentation to nearest multiple of shiftwidth
set shiftround

" do not redraw during macro execution
set lazyredraw

if has('persistent_undo')
  set undodir=~/.vim-undo,/tmp/vim-undo/
  set undofile
endif

set noswapfile

set completeopt=menu,menuone,noselect

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=build/*,*/build/*

function! s:Autosave()
    if &modified && filereadable(expand("%:p"))
        silent! write
    endif
endfunction

" Wrap all autocmds in an augroup so re-sourcing doesn't duplicate them.
augroup UserVimrc
  autocmd!
  " save on losing focus
  autocmd FocusLost,TabLeave,BufLeave * call <SID>Autosave()

  autocmd BufWritePre *.dart silent! lua vim.lsp.buf.format()

  " check for external changes on gaining focus on real file
  autocmd FocusGained,BufEnter */* checktime

  " large file compatibility mode
  autocmd BufReadPre * call <SID>LargeFile(expand("<afile>"))
augroup END

function! s:LargeFile(fname)
  let size = getfsize(a:fname)
  if size > -2 && size <= 1000000
    return
  endif
  setlocal noswapfile nobackup nowritebackup bufhidden=unload
  setlocal foldmethod=manual nofoldenable
  setlocal complete-=wbuU
  if size == -2
    setlocal ul=-1
  endif
  syntax sync clear
endfunction
