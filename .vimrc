call pathogen#infect()

set nocompatible
set number
syn on
set backspace=indent,eol,start
filetype plugin on
filetype plugin indent on

set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent

set encoding=utf-8
set spelllang=de_de

set scrolloff=4 " keep three lines visible above and below
set ignorecase
set smartcase   " unless search uses uppercase letters
" set gdefault    " always replace with /g

" save on losing focus
" au FocusLost * :wa
au TabLeave * :wa

" search with very magic on (shift-alt-f in neo)
map φ /\v
" replace with very magic on (shift-alt-g in neo)
map γ :%s/\v

" make current file's directory default for window (shift-alt-d in neo)
map δ :lcd %:p:h<CR>
" make on shift-alt-m
map μ :!make<CR>

" ctrl-q to esc
map <C-q> <Esc>
imap <C-q> <Esc>
smap <C-q> <Esc>
" f2 to write
nmap <F2> :w<CR>
" Ctrl-o for PeepOpen
map <C-o> \p

" select pasted text on \v
nnoremap <leader>v V`]
" horizontal split on \s
nnoremap <leader>s :split<CR><C-k>
" list yanks on \y
nnoremap <leader>y :YRShow<CR>

" insert mode navigation
imap <S-Tab> <Esc>A
imap <S-A-CR> <Esc>jA
imap <S-CR> <Esc>o
imap <S-A-BS> <Esc>kA
imap <S-BS> <Esc>O

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

command RSpec !rspec %
command RS !rspec %
command RSpecDoc !rspec % --format documentation
command RSD !rspec % --format documentation

let g:EasyMotion_leader_key = '<Leader>'
let g:yankring_history_dir = '$VIM'

" temporary short access for directory
cnoreabbrev cdmg lcd ~/Dropbox/Lars\ und\ Nino/spiel/maingame\ 2/
cnoreabbrev cdln lcd ~/Dropbox/Lars\ und\ Nino/
cnoreabbrev cdpr lcd /Volumes/BoxCryptor/Programmieren/
cnoreabbrev cdrb lcd /Volumes/BoxCryptor/Programmieren/Ruby/
cnoreabbrev cdun lcd /Volumes/BoxCryptor/Text\ und\ Schrift/Uni/Notizen/
cnoreabbrev cdws lcd ~/Documents/workspace/

" open shell command in buffer with :Shell or :shell
ca shell Shell
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
