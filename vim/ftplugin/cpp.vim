" cmake (shift-alt-c)
map <buffer> χ :call ProjectDirectoryDo("!cmake ..", "build")<CR>

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
