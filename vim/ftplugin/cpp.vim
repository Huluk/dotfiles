let b:commentary_format = '// %s'
" switch between header and cc
map <leader>r :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>
