" ===== WORK SETUP? =====
let g:at_work = isdirectory('/google') && !has('macunix')
let g:work_laptop = isdirectory('/google') && has('macunix')

if g:at_work
  let g:lsp = 'cmp'
elseif g:work_laptop
  let g:lsp = 'nvim'
else " at home
  let g:lsp = 'cmp'
endif

" ===== PLUGINS =====
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" === Nvim Specials ===
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " Lua utils, dependency of telescope and others.
  Plug 'nvim-lua/plenary.nvim'
  " Fuzzyfinder
  Plug 'nvim-telescope/telescope.nvim'
  " Fast fzf sorting
  Plug 'nvim-telescope/telescope-fzf-native.nvim'
  " Frequent/recent file open
  Plug 'nvim-telescope/telescope-frecency.nvim'
endif

" === Editing ===
" make `.` work with tpope's plugins
Plug 'tpope/vim-repeat'
" surround words and other units with parens, quotes etc.
Plug 'tpope/vim-surround'
" comment stuff out with gcc, gc etc.
Plug 'tpope/vim-commentary'
" increment/decrement dates/times etc, same as normal numbers
Plug 'tpope/vim-speeddating'
" tree structure for undo/redo operations
Plug 'mbbill/undotree'
" jump to last line on file open
Plug 'farmergreg/vim-lastplace'

" === Highlighting ===
" highlight text outside of textwidth
Plug 'whatyouhide/vim-lengthmatters'
" auto-remove search highlight on cursor movement
Plug 'junegunn/vim-slash'
" color-coded parentheses
" TODO Try this again when it is more stable.
" Plug 'hiphish/rainbow-delimiters.nvim'
if has('nvim')
  " auto-disable highlight after some time
  " Note: Temporary using fork to circumvent search error (issue #2)
  Plug 'senilio/timed-highlight.nvim'
  " Plug 'sahlte/timed-highlight.nvim'
endif

" === Integration ===
" git wrapper
Plug 'tpope/vim-fugitive'
" fix tmux focus integration
Plug 'tmux-plugins/vim-tmux-focus-events'
" tmux split navigation
Plug 'christoomey/vim-tmux-navigator'
if has('nvim') && g:at_work
  " mercurial wrapper
  Plug 'ludovicchabant/vim-lawrencium'
  " Auto-refresh work credentials
  Plug 'sso://user/fentanes/gcert.nvim'
  " codesearch integration
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'sso://user/vintharas/telescope-codesearch.nvim'
endif
if !has('nvim-0.10')
  " tmux remote clipboard
  Plug 'ojroques/nvim-osc52'
endif
" open at line number after colon
Plug 'wsdjeg/vim-fetch'

" === Optics ===
" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('nvim')
  " solarized theme
  Plug 'icymind/NeoSolarized'
  if !g:at_work
    " molokai theme
    Plug 'ofirgall/ofirkai.nvim'
  endif
endif

" === Language-specific ===
if has('nvim')
  " language server
  Plug 'neovim/nvim-lspconfig'
  if g:lsp == 'cmp'
    " Buffer-based completion
    Plug 'hrsh7th/cmp-buffer'
    " LSP-based completion
    Plug 'hrsh7th/cmp-nvim-lsp'
    " Snippet engine
    Plug 'hrsh7th/cmp-vsnip'
    " Lua api completion
    Plug 'hrsh7th/cmp-nvim-lua'
    " Main completion engine
    Plug 'hrsh7th/nvim-cmp'
    " Snippet engine, part 2
    Plug 'hrsh7th/vim-vsnip'
    if g:at_work
      Plug 'sso://user/piloto/cmp-nvim-ciderlsp'
    endif
  elseif g:lsp == 'coq'
    " async autocomplete
    Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
    Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
  endif
endif
" auto-add end statements of indented code blocks
Plug 'tpope/vim-endwise', { 'for': ['ruby', 'lua'] }

" === Other ===
" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'
if has('nvim')
  " hotkey tooling, needs plenary
  Plug 'tris203/hawtkeys.nvim'
endif

" === Dev ===
if isdirectory($HOME.'/Documents/exreader')
  " TODO requires UpdateRemotePlugins
  Plug '~/Documents/exreader'
endif

call plug#end()


" ===== KEY MAPS =====

" Maps system:
"
" <leader>
" • anything related to vim itself
" • language-agnostic commands
" • LSP commands which modify the code
" Neo greek layer
" • LSP info
" <localleader>
" • language-specific file actions or commands
"
" Additional maps may be defined in ftplugin/*, work.vim, and the lsp/ config.

" set leaders
let mapleader = ","
let maplocalleader = "\\"

" GENERAL MAPS

" alt-ß (neo-layout) / ſ to esc
map <silent> ſ <Esc>:nohlsearch<CR>
map! ſ <Esc>

" tab switching
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabnew<CR>

" decrement/increment number under cursor
nmap + <c-a>
nmap - <c-x>

" re-select after indenting selection
vnoremap < <gv
vnoremap > >gv

" LEADER MAPS

" make current file's directory default for window
nmap <leader>d :lcd %:p:h<CR>

" fuzzyfinder open
nmap <leader>e :FZF<CR>

" make
map <leader>m :make<CR>
" add execution environment comment to top of file
nmap <leader>! :execute "normal ggO#!/usr/bin/env ".&filetype<CR>
" make current file unix executable
nmap <leader>o :!chmod +x %:S<CR>l

" select pasted text
nmap <silent> <leader>s V`]

" uppercase previous word
inoremap <c-ü> <Esc>bgU$A

" horizontal split
nmap <leader>h :split<CR><C-w>j
" vertical split
nmap <leader>v :vsplit<CR><C-w>l

" LOCALLEADER MAPS

" spell correction
nmap <localleader>de :setlocal spell spelllang=de_20<CR>
nmap <localleader>nl :setlocal spell spelllang=nl_nl<CR>
nmap <localleader>eo :setlocal spell spelllang=eo_l3<CR>
nmap <localleader>en :setlocal spell spelllang=en<CR>
nmap <localleader>gb :setlocal spell spelllang=en_gb<CR>
nmap <localleader>uk :setlocal spell spelllang=en_gb<CR>
nmap <localleader>us :setlocal spell spelllang=en_us<CR>


" ===== SETTINGS =====
if has('nvim')
  if g:at_work || g:work_laptop
    colorscheme NeoSolarized
  else
    colorscheme ofirkai
  endif
  luafile $HOME/.vim/lua/config.lua
else
  " nvim-compatibility for vim
  source ~/.vim/non-nvim.vim
endif

" work-specific tooling
if g:at_work
  source $HOME/.vim/work.vim
  " fix expand not showing a relative path
  lcd .
endif

set number
if !g:at_work
  set relativenumber
  set cursorline
endif
set signcolumn=number

set ignorecase
set smartcase

" allow cursor movements to empty fields for block selection
set virtualedit=block

set mouse=a

set scrolloff=4
set sidescrolloff=5

" enable with :set list
" position in long non-wrap line: precedes:← extends:→
set listchars=precedes:\\u2190,extends:\\u2192
" line break:¬ non-breaking space:␣
set listchars+=eol:\\xAC,nbsp:\\\u2423
" tab:⊳⋅⋅⋅ trailing space:⌁
set listchars+=tab:\\u22b3\\u22c5,trail:\\u2301

" shows symbol on line wrap
set showbreak=↪

set breakindent
set textwidth=80
" break line at specific chars
set linebreak

set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=-1

" folding
set foldmethod=syntax
set foldminlines=3
set nofoldenable

" round indentation to nearest multiple of shiftwidth
set shiftround

" do not redraw during macro execution
set lazyredraw

if has('persistent_undo')
  set undodir=~/.vim-undo,/tmp/vim-undo/
  set undofile
endif

set noswapfile

set completeopt=menu,menuone,noselect

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*

" save on losing focus
autocmd FocusLost,Tableave,BufLeave * call <SID>Autosave()
function! s:Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction

autocmd BufWritePre *.dart silent! lua vim.lsp.buf.format()

" check for external changes on gaining focus on real file
autocmd FocusGained,BufEnter */* checktime

" large file compatibility mode
autocmd BufReadPre * call <SID>LargeFile(expand("<afile>"))
function! s:LargeFile(fname)
  let size = getfsize(a:fname)
  if size > -2 && size <= 1000000
    return
  endif
  setlocal noswapfile nobackup nowritebackup bufhidden=unload
  setlocal foldmethod=manual nofoldenable
  setlocal complete-=wbuU
  if size == -2
    setlocal ul=-1
  endif
  syntax sync clear
endfunction


" ===== PLUGIN CONFIG =====

call lengthmatters#highlight_link_to('FoldColumn')

" airline statusline
" don't display file encoding and file format if it is the expected value
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
" don't display default branch
let g:airline#extensions#branch#format = 'CleanBranchName'
function! CleanBranchName(name)
  if index(['default', 'master', 'main'], a:name) >= 0
    return ''
  else
    return a:name
  endif
endfunction " don't display branch marker for 'dirty'
let g:airline#extensions#branch#vcs_checks = ['untracked']
" don't display filetype at all
let g:airline_section_x = ''
" show file line count in position section
let g:airline_section_z =
      \ '%p%% ' .
      \ '%l%#__accent_bold#/%L%#__restore__#' .
      \ ':%3v'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#buf_label_first = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#overflow_marker = '…'
function! FormatTabNr(tab_nr, buflist)
  let split_nr = len(tabpagebuflist(a:tab_nr))
  if split_nr > 1
    return g:airline_symbols.space . split_nr
  else
    return ''
  endif
endfunction
let g:airline#extensions#tabline#tabnr_formatter = 'FormatTabNr'
" See help for filename-modifiers.
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
