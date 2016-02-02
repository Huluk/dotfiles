setlocal expandtab
setlocal softtabstop=2
setlocal shiftwidth=2
" run current file (ρ is shift-alt-r in neo layout
map <buffer> ρ :w<CR>:!ruby %:gs? ?\\ ?<CR>
" run current file in rspec (σ is shift-alt-r in neo layout
map <buffer> σ :w<CR>:!rspec %:gs? ?\\ ?<CR>

" print output behind #=>
map <buffer> <Leader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)
xmap <buffer> <Leader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)
imap <buffer> <Leader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)

" make runable
map <buffer> <Leader>rb i#!/usr/bin/ruby<CR><BACKSPACE><CR><ESC>

" ctag support
setlocal iskeyword-=?
setlocal iskeyword-=!

command! RSpec !rspec %
command! RS !rspec %
command! RSpecDoc !rspec % --format documentation
command! RSD !rspec % --format documentation

command! -nargs=1 RB silent! !open -a /Applications/Firefox.app/ "http://ruby-doc.org/core/classes/<args>.html"
