" Works for work setup (g:at_work) only

" NOTE:
" My current version of vim-lsp's autoload/lsp.vim has the following line
" removed from `s:fire_lsp_buffer_enabled`:
" exec printf('autocmd BufEnter <buffer=%d> ++once doautocmd User lsp_buffer_enabled', a:buf)

nnoremap <S-k> :LspHover<CR>
nmap <leader>f :LspCodeAction<CR>
nmap <leader>i :YcmShowDetailedDiagnostic<CR>
nmap τ :LspPeekTypeDefinition<CR>

nmap <leader>g :LspPeekDefinition<CR>
nmap γ :LspPeekDeclaration<CR>
nmap φ :LspReferences<CR>

nmap ρ :LspRename<space>
" (omikron, shift-alt-o in neo)
nmap ο :YcmCompleter OrganizeImports<CR>

" open current line in Code Search
nmap <leader>c :echo system("xdg-open '" . substitute(expand("%:p"), '.*google3/', 'https://cs.corp.google.com/piper///depot/google3/', '') . '?l=' . line('.') . "'")<CR><CR>

" error navigation - overrides sentence navigation!
nmap ( :LspPreviousDiagnostic<CR>
nmap ) :LspNextDiagnostic<CR>

nmap <leader>d :LspDocumentDiagnostics<CR>
nmap <leader>D :lclose<CR>

au User lsp_setup call lsp#register_server({
      \ 'name': 'CiderLSP',
      \ 'cmd': {server_info->[
      \   '/google/bin/releases/editor-devtools/ciderlsp',
      \   '--tooltag=vim-lsp',
      \   '--noforward_sync_responses',
      \   '--hub_addr=blade:languageservices-staging',
      \ ]},
      \ 'whitelist': [
      \   'c', 'cpp', 'java', 'proto', 'python', 'textproto', 'go', 'swift'
      \ ],
      \})
let g:lsp_async_completion = 0
let g:lsp_preview_float = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_enabled = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_signature_help_enabled = 0

let g:asyncomplete_smart_completion = 0
let g:asyncomplete_auto_popup = 0
let g:asyncomplete_auto_completeopt = 0
