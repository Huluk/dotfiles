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

" === Highlighting ===
" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'

" === Language-specific ===
" auto-add end statements of indented code blocks
Plug 'tpope/vim-endwise', { 'for': ['ruby', 'lua'] }

" === Other ===
" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'

" === Dev ===
Plug 'dstein64/vim-startuptime'

call plug#end()


" ===== KEY MAPS FOR COMPATIBILITY =====

set nocompatible
set encoding=utf-8
syntax on
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
