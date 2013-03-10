" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile .pentadactylrc setfiletype vim
    au! BufRead,BufNewFile .vimperatorrc setfiletype vim
augroup END
