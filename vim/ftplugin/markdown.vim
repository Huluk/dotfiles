" current file as pdf
map <buffer> <leader>r :w<CR>:!pandoc -o %:r:gs? ?\\ ?.pdf %:gs? ?\\ ?<CR>

map <buffer> <leader>c :CountDone<CR>

setlocal softtabstop=2
setlocal shiftwidth=4

" doesn't work
"hi markdownItalic term=standout cterm=standout
