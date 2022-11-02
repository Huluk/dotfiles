" switch to test file
map <localleader>t :e %:p:s!java!javatests!:s!\.java$!Test.java!<CR>
map <localleader>T :tabnew %:p:s!java!javatests!:s!\.java$!Test.java!<CR>
" switch to code file
map <localleader>c :e %:p:s!javatests!java!:s!Test\.java$!.java!<CR>
map <localleader>C :tabnew %:p:s!javatests!java!:s!Test\.java$!.java!<CR>
