" Enable modern Vim features not compatible with Vi spec.
set nocompatible

" Use the 'google' package by default (see http://go/vim/packages).
source /usr/share/vim/google/google.vim
source ~/.vim/g4blame.vim

" Plugin configuration.
" See http://google3/devtools/editors/vim/examples/ for example configurations
" and http://go/vim/plugins for more information about vim plugins at Google.

" Plugin loading is commented out below - uncomment the plugins you'd like to
" load.

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

" Load YCM (http://go/ycm) for semantic auto-completion and quick syntax
" error checking. Pulls in a google3-enabled version of YCM itself and
" a google3-specific default configuration.
Glug youcompleteme-google

" Load the automated blaze dependency integration for Go.
" Note: for Go, blazedeps uses the Go team's glaze tool, which is fully
" supported by the Go team. The plugin is currently unsupported for other
" languages.
"Glug blazedeps auto_filetypes=`['go']`

" Load piper integration (http://go/VimPerforce).
Glug piper plugin[mappings]

" Load g4 integration
Glug g4

" Load Critique integration. Use :h critique for more details.
Glug critique plugin[mappings]

" Load blaze integration (http://go/blazevim).
Glug blaze plugin[mappings]

" Load the syntastic plugin (http://go/vim/plugins/syntastic-google).
" Note: this requires installing the upstream syntastic plugin from
" https://github.com/scrooloose/syntastic.
"Glug syntastic-google

" Load the ultisnips plugin (http://go/ultisnips).
" Note: this requires installing the upstream ultisnips plugin from
" https://github.com/SirVer/ultisnips.
"Glug ultisnips-google

" All of your plugins must be added before the following line.
" See go/vim-plugin-manager if you need help picking a plugin manager and
" setting it up.

" ===== LANGUAGE-SPECIFIC =====
Glug ft-cpp
Glug ft-python
Glug ft-javascript
Glug ft-java

" Glug glug sources+=`$HOME . '/.vim/local'`
" Glug glint-ale

" ===== ALIASES =====
cnoremap Jeval e java/com/google/lens/eval
cnoremap Jevals e java/com/google/lens/eval/evalservice
cnoremap Jteval e javatests/com/google/lens/eval
cnoremap Jtevals e javatests/com/google/lens/eval/evalservice
