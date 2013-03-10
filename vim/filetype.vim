" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile .pentadactylrc setfiletype vim
    au! BufRead,BufNewFile .vimperatorrc setfiletype vim
    au! BufRead,BufNewFile *.tex setfiletype tex
    au! BufRead,BufNewFile *.zsh-theme setfiletype sh
augroup END
