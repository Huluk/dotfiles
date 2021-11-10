map <leader>r :execute 'tabnew' substitute(substitute(expand("%"), "java", "javatests", ""), "\\.java", "Test.java", "")<CR>
