Glug youcompleteme-google

let b:commentary_format = '// %s'

if !g:at_work && executable('clang++')
  let g:syntastic_cpp_compiler = 'clang++'
  let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
endif
