command -nargs=0 NewWeek call weekplan#NewWeek()
map <Leader>nw :NewWeek<CR>

command -nargs=0 CountDone call weekplan#CountPomodoros("Done")
