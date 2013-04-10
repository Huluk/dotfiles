"compile on S-A-b (make bin)"
map β :w<CR>:!make %:r<CR>
"run on S-A-r"
map ρ :call ProjectDirectoryDo("!".FindExecutable(), "bin")<CR>
"run with valgrind on S-A-s"
map σ :execute ProjectDirectoryDo("Valgrind ".FindExecutable(), "bin")<CR>d10d

"use valgrind"
command! -complete=file -nargs=* Valgrind Shell valgrind <q-args>

function! FindExecutable()
    if filereadable(expand("%:r"))
        return expand("%:r")
    elseif filereadable(expand("%:t:r"))
        return '\./' . expand("%:t:r")
    elseif IsSourceDirectory() && filereadable("../bin/".expand("%:t:r"))
        return '../bin/'.expand("%:t:r")
    else
        throw "cannot find executable!"
    endif
endfunction
