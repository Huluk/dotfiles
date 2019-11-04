" error information
nmap <leader>i :LspHover<CR>
" go to definition (shift-alt-t in neo)
nmap τ :LspDefinition<CR>
" find references (shift-alt-f in neo)
nmap φ :LspReferences<CR>
" info about object (shift-alt-b in neo)
nmap β :LspTypeDefinition<CR>
" move between errors - overrides sentence navigation!
nmap ( :LspPreviousError<CR>
nmap ) :LspNextError<CR>
" auto-fix
nmap <leader>f :LspCodeAction<CR>
" rename
nmap ρ :LspRename<space>
