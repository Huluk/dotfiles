call pathogen#infect()

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

set scrolloff=3 "keep three lines visible above and below
set smartcase   "unless search uses uppercase letters

set spelllang=de_de
" ctrl-s to swap case of first letter of last word
map <C-s> b~e
imap <C-s> <Esc>b~ea
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
" insert mode navigation
imap <S-Tab> <Esc>A
imap <S-A-CR> <Esc>jA
imap <S-CR> <Esc>o
imap <S-A-BS> <Esc>kA
imap <S-BS> <Esc>O

command RSpec !rspec %
command RS !rspec %
command RSpecDoc !rspec % --format documentation
command RSD !rspec % --format documentation

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
