call pathogen#infect()

set nocompatible
set number
syn on
set backspace=indent,eol,start
set virtualedit=block
filetype plugin on
filetype plugin indent on

set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent

set encoding=utf-8
set spelllang=de_de

" terminal color support
set t_Co=256
color solarized " previous: tir_black

" terminal mouse support
set mouse=a

" allow <D-v> for pasting
" set clipboard=unnamed

" set relativenumber

set scrolloff=4 " keep three lines visible above and below
set ignorecase
set smartcase   " unless search uses uppercase letters
" set gdefault    " always replace with /g

" folding
set foldmethod=syntax
set nofoldenable
" open all folds in file (shift-alt-f)
map φ :%foldopen!<CR>:set nofoldenable<CR>

" make current file's directory default for window (shift-alt-d in neo)
map δ :lcd %:p:h<CR>
" make on shift-alt-m
map μ :!make<CR>

" decrease/increase number
noremap + <c-a>
noremap - <c-x>

" ctrl-q/ß to esc
map <C-ß> <Esc>
imap <C-ß> <Esc>
smap <C-ß> <Esc>
map <C-q> <Esc>
imap <C-q> <Esc>
smap <C-q> <Esc>
" f2 to write
nmap <F2> :w<CR>
" Ctrl-o for PeepOpen
" map <C-o> \p
" Ctrl-s for swap case of first Letter of previous word
map <C-s> m`b~``
imap <C-s> <Esc>m`b~``
" Y works as D
noremap Y y$

" set second leader
map , \

" select pasted text on \s
nnoremap <leader>s V`]
" horizontal split on \h
nnoremap <leader>h :split<CR><C-w>j
" vertical split on \v
nnoremap <leader>v :vsplit<CR><C-w>l
" list yanks on \y
nnoremap <leader>y :YRShow<CR>

" insert mode navigation
imap <S-A-CR> <Esc>jA
imap <S-CR> <Esc>o
imap <S-A-BS> <Esc>kA
imap <S-BS> <Esc>O

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" save on losing focus
au FocusLost * :silent! w
au TabLeave * :silent! wa
au BufLeave * :silent! w

" ctags
function! GenerateCtags()
   if filereadable("Makefile")
       silent !ctags -R &
       echo "Generated Ctags for project!"
   else
       lcd %:p:h
       if filereadable("Makefile")
           GenerateCtags
       else
           silent! !ctags -R %
           if filereadable("tags")
               echo "Generated Ctags for file!"
           else
               echo "Could not generate Ctags!"
           endif
       endif
   endif
endfunction
command! -nargs=0 GenerateCtags call GenerateCtags()

" after save
function! AfterSave()
    silent! SyntasticCheck
    silent! GenerateCtags
endfunction
command! -nargs=0 AfterSave call AfterSave()

" jump to ctag under cursor
map τ g]1<CR><CR> 
" manually generate ctags
noremap <Leader>gc :GenerateCtags<CR>
" autogenerate ctags for ruby, java, c
au BufWritePost *.rb,*.py,*.java,*.c,*.h AfterSave

" Project-wide search
function! ProjectWideSearch(str)
    execute "lvimgrep" . a:str . " **/*|lw"
endfunction

function! ProjectWideSearchWithPath(str)
    execute "lvimgrep" . a:str . "|lw"
endfunction

command! -nargs=* P call ProjectWideSearch( '<args>' )
command! -nargs=* Ps call ProjectWideSearchWithPath( '<args>' )

" if has('ruby')
"     " Unicode normalization (NFC)
"     command NFC !ruby ~/.vim/nfc_normalize.rb %
"     command Normalize NFC
" endif

" maximise
function! Max()
    set columns=1000
    set lines=100
endfunction
command! -nargs=0 Max call Max()

" toggle navigation for texts with wrapped lines:
let g:wrappedLineNavigation = 0
function! WrappedLineNavigationToggle()
    if g:wrappedLineNavigation == 0
        unmap j
        unmap k
        unmap $
        unmap 0
        let g:wrappedLineNavigation = 1
        echo "Code navigation active"
    else
        noremap j gj
        noremap k gk
        noremap $ g$
        noremap 0 g0
        let g:wrappedLineNavigation = 0
        echo "Text navigation active"
    endif
endfunction
noremap <Leader>nav :call WrappedLineNavigationToggle()<CR>

let g:EasyMotion_leader_key = '<Leader>'
let g:yankring_history_dir = '$HOME'
let g:yankring_history_file = '.yankring_history'

" temporary short access for directory
cnoreabbrev cdmg lcd ~/Dropbox/Lars\ und\ Nino/spiel/maingame\ 2/
cnoreabbrev cdln lcd ~/Dropbox/Lars\ und\ Nino/
cnoreabbrev cdpr lcd /Volumes/BoxCryptor/Programmieren/
cnoreabbrev cdrb lcd /Volumes/BoxCryptor/Programmieren/Ruby/
cnoreabbrev cdun lcd /Volumes/BoxCryptor/Text\ und\ Schrift/Uni/Notizen/
cnoreabbrev cdws lcd ~/Documents/workspace/

" open shell command in buffer with :Shell or :shell
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
