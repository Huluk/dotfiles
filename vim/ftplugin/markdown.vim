" current file as pdf
map <buffer> <leader>r :w<CR>:!pandoc -o %:r:gs? ?\\ ?.pdf %:gs? ?\\ ?<CR>

map <buffer> <leader>c :CountDone<CR>

set softtabstop=2
set shiftwidth=2

" doesn't work
"hi markdownItalic term=standout cterm=standout
