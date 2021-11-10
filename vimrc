if isdirectory('/google') && !has('macunix')
  let g:at_work = 1
  source $HOME/.vim/work.vim
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

Plug 'tpope/vim-endwise'

Plug 'mbbill/undotree'

" like fugitive, but for mercurial
Plug 'ludovicchabant/vim-lawrencium'

" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'

" fzf fuzzyfinder
Plug 'junegunn/fzf'

" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'

" highlight text outside of textwidth
Plug 'whatyouhide/vim-lengthmatters'

" todo manager
Plug 'davidoc/taskpaper.vim'

" fix tmux focus integration
Plug 'tmux-plugins/vim-tmux-focus-events'
" tmux split navigation
Plug 'christoomey/vim-tmux-navigator'

" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if has('nvim')

  " autocomplete
  Plug 'icymind/NeoSolarized'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  if g:at_work
    " language server + linting
    Plug 'neovim/nvim-lspconfig'
    Plug 'Shougo/deoplete-lsp'
  else
    " syntax files for autocomplete
    Plug 'Shougo/neco-syntax'
  endif
elseif !g:at_work
  " language server + linting
  " TODO Migrate private lsp usage to nvim-lsp
  Plug 'w0rp/ale'

  " Monkey C syntax highlighting
  Plug 'tipishev/vim-monkey-c'

  Plug 'editorconfig/editorconfig-vim'
endif

call plug#end()

" TODO what's this?
" Enable file type based indent configuration and syntax highlighting.
" Note that when code is pasted via the terminal, vim by default does not detect
" that the code is pasted (as opposed to when using vim's paste mappings), which
" leads to incorrect indentation when indent mode is on.
" To work around this, use ":set paste" / ":set nopaste" to toggle paste mode.
" You can also use a plugin to:
" - enter insert mode with paste (https://github.com/tpope/vim-unimpaired)
" - auto-detect pasting (https://github.com/ConradIrwin/vim-bracketed-paste)


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

set breakindent
set breakindentopt=shift:4

set scrolloff=4
set sidescrolloff=5

set textwidth=80

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=-1

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

set noswapfile

set completeopt=

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*

" save on losing focus
" TODO replace with 'autowrite'?
autocmd FocusLost,Tableave,BufLeave * :call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction
if g:at_work
  function! MaybeFormatCode()
    " TODO do not FormatCode if in diff mode
    if expand("%:t") != 'lvs.borg' && !&diff
      FormatCode
    endif
  endfunction
  autocmd BufWritePre /google/* call MaybeFormatCode()
endif

" check for external changes on gaining focus
" TODO how does this relate to 'autoread'?
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

" make
map <leader>m :make<CR>

" make current file's directory default for window (shift-alt-d in neo)
nmap δ :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

if g:at_work
  luafile $HOME/.vim/lsp/nvim_lsp.lua
else
  source $HOME/.vim/lsp/ale.vim
endif

" decrement/increment number under cursor
nmap + <c-a>
nmap - <c-x>

" re-select after indenting selection
vnoremap < <gv
vnoremap > >gv

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

let g:task_paper_search_hide_done = 1

" airline statusline
" don't display file encoding and file format if it is the expected value
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
" slightly change looks of line count section
let g:airline_section_z =
      \ '%3p%% ' .
      \ '%{g:airline_symbols.linenr}%4l%#__accent_bold#/%L%#__restore__# :%3v'
let g:airline#extensions#tagbar#enabled = 0

let g:ycm_auto_trigger = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_error_symbol = 'X'
let g:ycm_warning_symbol = 'w'

if has('nvim')

  let g:deoplete#enable_at_startup = 1

  call deoplete#custom#option({
                 \ 'auto_complete': v:false,
                 \ 'smart_case': v:true,
                 \ })

  " use <C-s> for deoplete autocomplete
  inoremap <silent><expr> <C-s>
              \ pumvisible() ? "\<C-n>" :
              \ deoplete#mappings#manual_complete()

endif
