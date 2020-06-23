set noexpandtab
nmap <buffer> <localleader>n :call taskpaper#toggle_tag('next', '')<CR>
nmap <buffer> <localleader>N :s/@next/@today<CR>

nmap <buffer> <localleader>p <Plug>TaskPaperFoldProjects
nmap <buffer> <localleader>. <Plug>TaskPaperFoldNotes
nmap <buffer> <localleader>P <Plug>TaskPaperFocusProject

nmap <buffer> <localleader>/ <Plug>TaskPaperSearchKeyword
nmap <buffer> <localleader>s <Plug>TaskPaperSearchTag

nmap <buffer> <localleader>g <Plug>TaskPaperGoToProject
nmap <buffer> <localleader>j <Plug>TaskPaperNextProject
nmap <buffer> <localleader>k <Plug>TaskPaperPreviousProject

nmap <buffer> <localleader>D <Plug>TaskPaperArchiveDone
nmap <buffer> <localleader>T <Plug>TaskPaperShowToday
nmap <buffer> <localleader>X <Plug>TaskPaperShowCancelled
nmap <buffer> <localleader>d <Plug>TaskPaperToggleDone
nmap <buffer> <localleader>t <Plug>TaskPaperToggleToday
nmap <buffer> <localleader>x <Plug>TaskPaperToggleCancelled
nmap <buffer> <localleader>m <Plug>TaskPaperMoveToProject
