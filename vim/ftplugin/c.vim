"compile on S-A-b (make bin)"
map β :w<CR>:!make %:r<CR>
"run on S-A-r"
map ρ :call ProjectDirectoryDo("!".FindExecutable(), "bin")<CR>
"run with valgrind on S-A-s"
map σ :execute ProjectDirectoryDo("Valgrind ".FindExecutable(), "src")<CR>d10d

"use valgrind"
command! -complete=file -nargs=* Valgrind Shell valgrind <q-args>

function! FindExecutable()
    if filereadable(expand("%:r"))
        return expand("%:r")
    elseif filereadable(expand("%:t:r"))
        return '\./' . expand("%:t:r")
    elseif IsSourceDirectory()
        if filereadable("../Makefile")
            return 'cd .. && make run'
        elseif filereadable("../bin/".expand("%:t:r"))
            return '../bin/'.expand("%:t:r")
        endif
    else
        throw "cannot find executable!"
    endif
endfunction
