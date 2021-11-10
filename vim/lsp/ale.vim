nnoremap <S-k> :ALEHover<CR>
nmap <leader>f :ALEFix<CR>
" missing: nmap <leader>i for diagnostics
" missing: nmap τ for get type

nmap <leader>g :ALEGoToDefinition<CR>
" missing: nmap γ for go to declaration
nmap φ :ALEFindReferences<CR>

" missing: nmap ρ for rename
" missing: nmap ο (omikron) for organize imports

" error navigation - overrides sentence navigation!
nmap <silent> ( <Plug>(ale_previous_wrap)
nmap <silent> ) <Plug>(ale_next_wrap)

let g:ale_sign_error = 'x'
let g:ale_sign_warning = 'w'
let g:ale_sign_info = 'i'
let g:ale_sign_style_error = 'x'
let g:ale_sign_style_warning = '-'

if g:at_work
  let g:ale_linters = {
        \ 'python': ['glint'],
        \ 'proto': ['glint'],
        \ 'java': ['glint'],
        \ 'javascript': ['glint'],
        \ 'cpp' : ['glint'],
        \}
else
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1

  let NERDTreeQuitOnOpen = 1
  let NERDTreeBookmarksFile = '$HOME/.vim/NERDTreeBookmarks'
endif
