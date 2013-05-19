call pathogen#infect()

call pathogen#infect('after_bundle{}')

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

set scrolloff=4 " keep x lines visible above and below

set ignorecase  " case insensitive search
set smartcase   " unless search uses uppercase letters
set wildignorecase " ignore file case on all systems
" set gdefault    " always replace with /g

" folding
set foldmethod=syntax
set nofoldenable
" open all folds in file (shift-alt-f)
map φ :set nofoldenable<CR>
" previous: :%foldopen!<CR>

" make current file's directory default for window (shift-alt-d in neo)
map δ :lcd %:p:h<CR>
" make on shift-alt-m
map μ :call ProjectDirectoryDo("!make", "build")<CR>
map <leader>m μ

" decrease/increase number
noremap + <c-a>
noremap - <c-x>

" ctrl-q/ß to esc
map ſ <Esc>
imap ſ <Esc>
vmap ſ <Esc>
map <C-ß> <Esc>
imap <C-ß> <Esc>
vmap <C-ß> <Esc>
smap <C-ß> <Esc>
map <C-q> <Esc>
imap <C-q> <Esc>
vmap <C-q> <Esc>
smap <C-q> <Esc>

" f2 to write
nmap <F2> :w<CR>
" Ctrl-o for PeepOpen
" map <C-o> \p
" Ctrl-s for swap case of first Letter of previous word
map <C-s> m`b~``
imap <C-s> <Esc>m`b~``a
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

" tab
map <leader>t :tabnew<CR>
map <Tab> gt
map <S-Tab> gT

map <leader>r ρ

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
au FocusLost,Tableave,BufLeave * :call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction

" dirname
function! Dirname()
    return expand("%:p:h:t")
endfunction

function! RelativePath()
    return expand("%:.:h")
endfunction

function! IsSourceDirectory()
    return (RelativePath() == '.' && Dirname() == "src")
endfunction

" project
function! IsProject()
    return filereadable("Makefile") || IsSourceDirectory()
endfunction

function! ProjectDirectoryDo(str, directory)
    if IsSourceDirectory() && finddir(a:directory, '..') != ""
        let working_directory = getcwd()
        execute "lcd ../".fnameescape(a:directory)
        execute a:str
        execute "lcd ".fnameescape(working_directory)
    else
        execute a:str
    endif
endfunction

function! ProjectRun()
    if IsSourceDirectory() && filereadable("../Makefile")
        call ProjectDirectoryDo("!make run", ".")
    else
        throw "No Makefile!"
    endif
endfunction
command! -nargs=0 ProjectRun call ProjectRun()

function! ProjectMakefile(name)
    if IsSourceDirectory()
        let fname = fnameescape(a:name)
        let text = "run:\\\\n\\\\tbin/".fname
        " ."\\\\n\\\\n"    Valgrind part does not work
        " let text = text."valgrind:\\\\n\\\\tvalgrind bin/".fname
        let text = '!echo '.text.' >> ../Makefile'
        execute text
    endif
endfunction
command! -nargs=1 -complete=file Pmk call ProjectMakefile('<args>')
nnoremap <Leader>pmk :Pmk %:t:r<CR>

" ctags
function! GenerateCtags()
   if IsProject()
       silent !ctags -R &
       echo "Generated Ctags for project!"
   else
       lcd %:p:h
       if IsProject()
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
    " silent! SyntasticCheck
    silent! GenerateCtags
endfunction
command! -nargs=0 AfterSave call AfterSave()

" jump to ctag under cursor
map τ g]1<CR><CR> 
" manually generate ctags
noremap <Leader>gc :GenerateCtags<CR>
" autogenerate ctags for ruby, java, c
au BufWritePost *.rb,*.py,*.java,*.c,*.cpp,*.h,*.hpp AfterSave

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
let g:wrappedLineNavigation = 1
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
let g:SuperTabNoCompleteAfter = ['^', ',', ';', '\s']
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
