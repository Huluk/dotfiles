" current file as pdf (ρ is shift-alt-r in neo layout
map ρ :w<CR>:!pandoc -o %:r:gs? ?\\ ?.pdf %:gs? ?\\ ?<CR>

map <leader>c :CountDone<CR>

" doesn't work
"hi markdownItalic term=standout cterm=standout
