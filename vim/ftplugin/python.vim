" run current file
set softtabstop=4
set tabstop=4
set shiftwidth=4
map <buffer> <leader>r :w<CR>:!python %:gs? ?\\ ?<CR>
