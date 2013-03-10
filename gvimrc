set go -=T
color ir_black
set guifont=Source\ Code\ Pro:h13 "old: Menlo:h13, default: Menlo:h11
" :set hls
" :nnoremap <C-q> :nohlsearch<CR>
nohlsearch
" add trackpad gestures support
map <D-A-a> <D-{>
imap <D-A-a> <D-{>
vmap <D-A-a> <D-{>
map <D-A-e> <D-}>
imap <D-A-e> <D-}>
vmap <D-A-e> <D-}>

" why doesn't this work in the first place (.vimrc)?
map Y y$

" disable mouse-over
:set noballooneval

" Unicode normalization (NFC)
rubydo require 'unicode'
command NFC rubydo $_ = Unicode::nfc($_)
command Normalize NFC
