let b:commentary_format = '// %s'

" switch to header
map <localleader>h :e %:p:s!\(_test\)\?\.cc$!.h!<CR>
map <localleader>H :tabnew %:p:s!\(_test\)\?\.cc$!.h!<CR>
" switch to cc
map <localleader>c :e %:p:s!_test\.cc$!.cc!:s!\.h$!.cc!<CR>
map <localleader>C :tabnew %:p:s!_test\.cc$!.cc!:s!\.h$!.cc!<CR>
" switch to test
map <localleader>t :e %:p:s!.cc$!_test.cc!:s!.h$!_test.cc!<CR>
map <localleader>T :tabnew %:p:s!.cc$!_test.cc!:s!.h$!_test.cc!<CR>
