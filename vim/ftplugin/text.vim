setlocal softtabstop=2
setlocal shiftwidth=2

" add execution environment comment to top of file
nnoremap <leader>! :set syntax=asciidoc<CR>:execute "normal Go// vim: set syntax=asciidoc:"<CR>
