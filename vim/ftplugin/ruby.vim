setlocal expandtab
setlocal softtabstop=2
setlocal tabstop=2
setlocal shiftwidth=2

" run current file
map <buffer> <leader> :w<CR>:!ruby %:gs? ?\\ ?<CR>
" run current file in rspec (σ is shift-alt-r in neo layout)
map <buffer> σ :w<CR>:!rspec %:gs? ?\\ ?<CR>

" print output behind #=>
map <buffer> <Localleader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)
xmap <buffer> <Localleader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)
imap <buffer> <Localleader>o <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)

" ctag support
setlocal iskeyword-=?
setlocal iskeyword-=!

command! RSpec !rspec %
command! RS !rspec %
command! RSpecDoc !rspec % --format documentation
command! RSD !rspec % --format documentation
