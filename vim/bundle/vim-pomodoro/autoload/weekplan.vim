let g:weekplan_copy_dict = {
            \ 'All Mondays':'Monday',
            \ 'All Tuesdays':'Tuesday',
            \ 'All Wednesdays':'Wednesday',
            \ 'All Thursdays':'Thursday',
            \ 'All Fridays':'Friday',
            \ 'All Saturdays':'Saturday',
            \ 'All Sundays':'Sunday',
            \ 'Always':'Today'}

let g:weekplan_pomodoro_count_regex =
            \ '"---? (?<result>\d*(\.\d)?)(\/\d*(\.\d)?)?$"'

let s:weekplan_manager_file = expand('<sfile>:p:h') . '/weekplan.rb'

let g:weekplan_title_recognition = '^\#'

function weekplan#NewWeek()
    let l:args = ''
    for key in keys(g:weekplan_copy_dict)
        let l:args = l:args . 'copy ' . 
                    \ shellescape(key) . ' ' .
                    \ shellescape(g:weekplan_copy_dict[key]) . ';'
    endfor
    call weekplan#Call(l:args)
endfunction

function weekplan#CountPomodoros(title)
    let l:args = 'count ' . a:title . ' ' . g:weekplan_pomodoro_count_regex
    call weekplan#Call(l:args)
endfunction

function weekplan#Call(args)
    execute '%!ruby ' . fnameescape(s:weekplan_manager_file) . ' ' . 
                \ g:weekplan_title_recognition . ' ' . shellescape(a:args)
endfunction
