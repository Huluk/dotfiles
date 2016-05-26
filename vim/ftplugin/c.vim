"compile on S-A-b (make bin)"
map <buffer> β :w<CR>:!make %:r<CR>

"use valgrind"
command! -complete=file -nargs=* Valgrind Shell valgrind <q-args>
