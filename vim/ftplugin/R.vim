setlocal commentstring=#\ %s

map <buffer> <leader>r :w<CR>:!Rscript %:gs? ?\\ ?<CR>
