execute pathogen#infect()

set nocompatible
syntax on
set backspace=indent,eol,start
set virtualedit=block
set encoding=utf-8

filetype plugin on
filetype plugin indent on

set number " show line number at position
set relativenumber " use relative line numbers

set scrolloff=4 " keep x lines visible above and below position
set ruler

set ignorecase  " case insensitive search
set smartcase   " unless search uses uppercase letters
" set gdefault    " always replace with /g

" always use soft tabstops of width 4
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set shiftround
set autoindent

" leaves enough space for line numbers
set textwidth=76

set shell=/bin/sh

" terminal color support
set t_Co=256
color solarized " previous: tir_black

" enable with :set list
set listchars=eol:¬,precedes:←,extends:→,tab:▶\

" shows symbol on line wrap
set showbreak=↪

" terminal mouse support
set mouse=a

" allow <D-v> for pasting and sync with system paste
" set clipboard=unnamed

" Y works like D
noremap Y y$

" set leaders
let mapleader = ","
let maplocalleader = "\\"

" folding
set foldmethod=syntax
set nofoldenable
" open all folds in file (shift-alt-f)
map φ :set nofoldenable<CR>
" previous: :%foldopen!<CR>

" make current file's directory default for window (shift-alt-d in neo)
map δ :lcd %:p:h<CR>

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

" add execution environment comment to top of file
nnoremap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" convert current file to unix executable on
nnoremap <leader>o :!chmod +x %:S<CR>l
" select pasted text
nnoremap <leader>s V`]
" horizontal split
nnoremap <leader>h :split<CR><C-w>j
" vertical split on
nnoremap <leader>v :vsplit<CR><C-w>l
" list yanks on
nnoremap <leader>y :YRShow<CR>

" tab
map <leader>t :tabnew<CR>
noremap <Tab> gt
noremap <S-Tab> gT
" restore ctrl-i for position change (aliased omikron, map also in iterm)
nnoremap ο <C-i>

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

" spell correction
map <LocalLeader>d :setlocal spell spelllang=de_20<CR>
map <LocalLeader>n :setlocal spell spelllang=nl_nl<CR>
map <LocalLeader>eo :setlocal spell spelllang=eo_l3<CR>
map <LocalLeader>en :setlocal spell spelllang=en<CR>
map <LocalLeader>g :setlocal spell spelllang=en_gb<CR>
map <LocalLeader>us :setlocal spell spelllang=en_us<CR>

" various make commands
map <leader>m :make<CR>
map <leader>x :make quick<CR>
map <leader>r :!%:p:S<CR>

" save on losing focus
au FocusLost,Tableave,BufLeave * :call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction

" close all tabs to direction
" TODO keeps non-saved buffers in background, even with bang
function! TabCloseRight(bang)
    let l:cur = tabpagenr('$')
    while l:cur > tabpagenr()
        exe 'tabclose' . a:bang . ' ' . l:cur
        let l:cur = l:cur - 1
    endwhile
endfunction

function! TabCloseLeft(bang)
    let l:cur = tabpagenr() - 1
    while l:cur >= 1
        exe 'tabclose' . a:bang . l:cur
        let l:cur = l:cur - 1
    endwhile
endfunction

command! -bang TabcloseRight call TabCloseRight('<bang>')
command! -bang TabcloseLeft call TabCloseLeft('<bang>')

map <Leader>tcl :TabcloseLeft<CR>
map <Leader>tcl! :TabcloseLeft!<CR>
map <Leader>tcr :TabcloseRight<CR>
map <Leader>tcr! :TabcloseRight!<CR>
map <Leader>tql :TabcloseLeft<CR>
map <Leader>tql! :TabcloseLeft!<CR>
map <Leader>tqr :TabcloseRight<CR>
map <Leader>tqr! :TabcloseRight!<CR>

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
           silent! !ctags -R %:S
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
function! RecursiveSearch(str)
    execute "lvimgrep" . a:str . " **/*|lw"
endfunction
function! RecursiveSearchWithPath(str)
    execute "lvimgrep" . a:str . "|lw"
endfunction

command! -nargs=* P call RecursiveSearch( '<args>' )
command! -nargs=* Ps call RecursiveSearchWithPath( '<args>' )

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

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let g:EasyMotion_leader_key = '<Leader>'
" let g:SuperTabNoCompleteAfter = ['^', ',', ';', '\s']
let g:yankring_history_dir = '$HOME'
let g:yankring_history_file = '.yankring_history'

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
