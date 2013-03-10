setlocal expandtab
setlocal softtabstop=2
setlocal shiftwidth=2
" run current file (ρ is shift-alt-r in neo layout
map ρ :w<CR>:!ruby %:gs? ?\\ ?<CR>
" run current file in rspec (σ is shift-alt-r in neo layout
map σ :w<CR>:!rspec %:gs? ?\\ ?<CR>

" make runable
map <Leader>rb i#!/usr/bin/ruby<CR><BACKSPACE><CR><ESC>

" ctag support
setlocal iskeyword-=?
setlocal iskeyword-=!

" disable mouseover
set balloonexpr=

command! RSpec !rspec %
command! RS !rspec %
command! RSpecDoc !rspec % --format documentation
command! RSD !rspec % --format documentation

command! -nargs=1 RB silent! !open -a /Applications/Firefox.app/ "http://ruby-doc.org/core/classes/<args>.html"
