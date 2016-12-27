" run current file
set softtabstop=2
set tabstop=2
set shiftwidth=2
map <buffer> <leader>r :w<CR>:!python %:gs? ?\\ ?<CR>
