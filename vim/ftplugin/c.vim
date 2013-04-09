"compile on S-A-b (make bin)"
:map β :w<CR>:!make %:r<CR>
"run on S-A-r"
:map ρ :!./%:.:r<CR>
"run with args on S-A-a"
:map α :!./%:.:r 
"run with valgrind on S-A-s"
:map σ :Valgrind ./%:.:r<CR>d10d

"use valgrind"
command! -complete=file -nargs=* Valgrind Shell valgrind <q-args>
