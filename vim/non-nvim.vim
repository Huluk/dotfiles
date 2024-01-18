set nocompatible
set encoding=utf-8
syntax on
filetype plugin on
filetype plugin indent on
set ruler
set complete-=i
set nrformats-=octal
set autoindent
set autoread
set backspace=indent,eol,start
set smarttab
set incsearch
set laststatus=2
set display+=lastline
set wildmenu
set tabpagemax=50
set sessionoptions-=options

" Y works like D (yank up to end of line)
map Y y$


" ===== PLUGIN CONFIG =====

let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#overflow_marker = '…'
" See help for filename-modifiers.
let g:airline#extensions#tabline#fnamemod = ':t'
