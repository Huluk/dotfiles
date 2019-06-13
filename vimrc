if isdirectory('/google')
  let g:at_work = 1
else
  let g:at_work = 0
endif

" ===== PLUGINS =====
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" make `.` work with tpope's plugins
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-surround'

" comment stuff out with gcc, gc etc.
Plug 'tpope/vim-commentary'

" increment/decrement dates/times etc, same as normal numbers
Plug 'tpope/vim-speeddating'

" git wrapper
Plug 'tpope/vim-fugitive'

" heuristically set tab options
Plug 'tpope/vim-sleuth'

" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'

" fzf fuzzyfinder
Plug '/usr/local/opt/fzf'

" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'

" highlight text outside of textwidth
Plug 'whatyouhide/vim-lengthmatters'

" yank history
Plug 'vim-scripts/YankRing.vim'

" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" directory tree sidebar
Plug 'scrooloose/nerdtree'

" language server + linting
Plug 'w0rp/ale'

if has('nvim')

  Plug 'icymind/NeoSolarized'

  " autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " syntax files for autocomplete
  Plug 'Shougo/neco-syntax'

endif

call plug#end()


" ===== SETTINGS =====
" nvim-compatibility for vim
if has('nvim')
  colorscheme NeoSolarized
else
  source ~/.vim/non-nvim.vim
endif

set number

set ignorecase
set smartcase

" allow cursor movements to empty fields for block selection
set virtualedit=block

set mouse=a

" enable with :set list
set listchars=eol:¬,precedes:←,extends:→,tab:▶\

" shows symbol on line wrap
set showbreak=↪

set scrolloff=4
set sidescrolloff=5

set textwidth=80

set tabstop=4

" folding
set foldmethod=syntax
set nofoldenable

" do not redraw during macro execution
set lazyredraw

" break line at specific chars
set linebreak

" round indentation to nearest multiple of shiftwidth
set shiftround

if has('persistent_undo')
  set undodir=~/.vim-undo/
  set undofile
endif

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*

" save on losing focus
autocmd FocusLost,Tableave,BufLeave * :call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction

" check for external changes on gaining focus
autocmd FocusGained,BufEnter * :checktime


" ===== KEY MAPPINGS =====
" set leaders
let mapleader = ","
let maplocalleader = "\\"

" alt-ß (neo-layout) / ſ to esc
map <silent> ſ <Esc>:nohlsearch<CR>
map! ſ <Esc>

" Y works like D (yank up to end of line)
map Y y$

" tab switching
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabnew<CR>

" directory tree sidebar
nmap <leader>d :NERDTreeToggle<CR>

" make
map <leader>m :make<CR>

" make current file's directory default for window (shift-alt-d in neo)
nmap δ :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

" ale go to definition (shift-alt-t in neo)
nmap τ :ALEGoToDefinition<CR>
" ale find references (shift-alt-f in neo)
nmap φ :ALEFindReferences<CR>
" ale info about object (shift-alt-b in neo)
nmap β :ALEHover<CR>
" move between errors - overrides sentence navigation!
nmap <silent> ( <Plug>(ale_previous_wrap)
nmap <silent> ) <Plug>(ale_next_wrap)
" auto-fix
nmap <leader>f :ALEFix<CR>

" decrement/increment number under cursor
noremap + <c-a>
noremap - <c-x>

" re-select after indenting selection
vnoremap < <gv
vnoremap > >gv

" split navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" add execution environment comment to top of file
nmap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" convert current file to unix executable
nmap <leader>o :!chmod +x %:S<CR>l
" select pasted text
nmap <leader>s V`]
" horizontal split
nmap <leader>h :split<CR><C-w>j
" vertical split
nmap <leader>v :vsplit<CR><C-w>l

" spell correction
nmap <LocalLeader>de :setlocal spell spelllang=de_20<CR>
nmap <LocalLeader>nl :setlocal spell spelllang=nl_nl<CR>
nmap <LocalLeader>eo :setlocal spell spelllang=eo_l3<CR>
nmap <LocalLeader>en :setlocal spell spelllang=en<CR>
nmap <LocalLeader>gb :setlocal spell spelllang=en_gb<CR>
nmap <LocalLeader>uk :setlocal spell spelllang=en_gb<CR>
nmap <LocalLeader>us :setlocal spell spelllang=en_us<CR>



" ===== PLUGIN CONFIG =====
call lengthmatters#highlight_link_to('FoldColumn')

let g:yankring_persist = 0

let NERDTreeQuitOnOpen = 1
let NERDTreeBookmarksFile = '$HOME/.vim/NERDTreeBookmarks'

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
" let g:ale_sign_error = '✖︎'
" let g:ale_sign_warning = '⚠︎'
" let g:ale_sign_info = 'ℹ︎'
" let g:ale_sign_style_error = '✖︎'
" let g:ale_sign_style_warning = '☞'

let g:ale_sign_error = 'x'
let g:ale_sign_warning = 'w'
let g:ale_sign_info = 'i'
let g:ale_sign_style_error = 'x'
let g:ale_sign_style_warning = '-'

" airline statusline
" don't display file encoding and file format if it is the expected value
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
" slightly change looks of line count section
let g:airline_section_z =
      \ '%3p%% ' .
      \ '%{g:airline_symbols.linenr}%4l%#__accent_bold#/%L%#__restore__# :%3v'
let g:airline#extensions#tagbar#enabled = 0
" redefine spell such that spelllang is shown for smaller window widths
" TODO repair!
" function! airline#parts#spell()
"   let out = g:airline_detect_spelllang
"         \ ? printf("[%s]", toupper(substitute(&spelllang, ',', '/', 'g')))
"         \ : g:airline_symbols.spell
"   if g:airline_detect_spell && &spell
"     if winwidth(0) >= 75
"       return out
"     else
"       return split(g:airline_symbols.spell, '\zs')[0]
"     endif
"   endif
"   return ''
" endfunction

if has('nvim')

  let g:deoplete#enable_at_startup = 1

  call deoplete#custom#option({
    \ 'auto_complete': v:false,
    \ 'smart_case': v:true,
    \ })

  " use <C-s> for deoplete autocomplete
  set completeopt-=preview
  inoremap <silent><expr> <C-s>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#mappings#manual_complete()

endif
