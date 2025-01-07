" Use the 'google' package by default (see http://go/vim/packages).
source /usr/share/vim/google/google.vim

" Load google's formatting plugins (http://go/vim/plugins/codefmt-google).
" The default mapping is \= (or <leader>= if g:mapleader has a custom value),
" with
" - \== formatting the current line or selected lines in visual mode
"   (:FormatLines).
" - \=b formatting the full buffer (:FormatCode).
"
" To bind :FormatLines to the same key in insert and normal mode, add:
"   noremap <C-K> :FormatLines<CR>
"   inoremap <C-K> <C-O>:FormatLines<CR>
"Glug codefmt plugin[mappings] gofmt_executable="goimports"
Glug codefmt-google

" Open in CodeSearch
Glug corpweb

" Java imports
Glug google-csimporter

" Open CNS paths
Glug googlepaths

" Enable autoformatting on save for the languages at Google that enforce
" formatting, and for which all checked-in code is already conforming (thus,
" autoformatting will never change unrelated lines in a file).
" Note formatting changed lines only isn't supported yet
" (see https://github.com/google/vim-codefmt/issues/9).
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType go AutoFormatBuffer gofmt
"  See go/vim/plugins/codefmt-google, :help codefmt-google and :help codefmt
"  for details about other available formatters.
augroup END

" ===== ALIASES =====
cnoremap Jeval e java/com/google/lens/eval
cnoremap Jevals e java/com/google/lens/eval/evalservice
cnoremap Jteval e javatests/com/google/lens/eval
cnoremap Jtevals e javatests/com/google/lens/eval/evalservice
cnoremap Vvsl e vision/visualsearch/server/lens

" switch to build file
" NOTE: there is Glug relatedfiles plugin which could replace these
map <localleader>b :e %:p:h/BUILD<CR>
map <localleader>B :tabnew %:p:h/BUILD<CR>

if has('nvim')
  luafile $HOME/.vim/lua/work.lua
endif

" search for visual selection
" TODO find equivalent for telescope search
nnoremap <leader>ws :call corpweb#CodeSearchLiteral(expand("<cword>"))<CR>
vnoremap <leader>ws :<C-U>call corpweb#CodeSearchLiteral(maktaba#buffer#GetVisualSelection())<CR>
" open current position in code search
map <leader>wo :CorpWebCsFile<CR>
" open cl in critique
map <leader>cl :CorpWebCritiqueCl<CR>
