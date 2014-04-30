let g:weekplan_copy_dict = {'All Mondays':'Monday','All Tuesdays':'Tuesday','All Wednesdays':'Wednesday','All Thursdays':'Thursday','All Fridays':'Friday','All Saturdays':'Saturday','All Sundays':'Sunday','Always':'Today'}

let s:weekplan_manager_file = expand('<sfile>:p:h') . '/weekplan.rb'

let g:weekplan_title_recognition = '^\#'

function weekplan#NewWeek()
    let l:args = ''
    for key in keys(g:weekplan_copy_dict)
        let l:args = l:args . 'copy ' . shellescape(key) . ' ' . shellescape(g:weekplan_copy_dict[key]) . ';'
    endfor
    execute '%!ruby ' . fnameescape(s:weekplan_manager_file) . ' ' . g:weekplan_title_recognition . ' ' . shellescape(l:args)
endfunction
