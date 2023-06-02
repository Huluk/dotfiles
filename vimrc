" ===== WORK SETUP? =====
let g:at_work = isdirectory('/google') && !has('macunix')
let g:work_laptop = isdirectory('/google') && has('macunix')

" ===== PLUGINS =====
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

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

" === Integration ===
" git wrapper
Plug 'tpope/vim-fugitive'
" mercurial wrapper
Plug 'ludovicchabant/vim-lawrencium'
" fix tmux focus integration
Plug 'tmux-plugins/vim-tmux-focus-events'
" tmux split navigation
Plug 'christoomey/vim-tmux-navigator'
" fzf fuzzyfinder
Plug 'junegunn/fzf'

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
  " " snippets
  " Plug 'hrsh7th/vim-vsnip'
  " " completion sources
  " Plug 'hrsh7th/cmp-nvim-lsp'
  " Plug 'hrsh7th/cmp-buffer'
  " Plug 'hrsh7th/cmp-nvim-lua'
  " Plug 'hrsh7th/cmp-path'
  " Plug 'hrsh7th/cmp-vsnip'
  " Plug 'hrsh7th/cmp-cmdline'
  " Plug 'hrsh7th/nvim-cmp'
  " " stuff, probably delete
  " Plug 'onsails/lspkind.nvim'
  " diagnostics
  " TODO actually use
  Plug 'folke/trouble.nvim'
  " async autocomplete
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
endif
" auto-add end statements of indented code blocks
" Plug 'tpope/vim-endwise'

" === Other ===
" extend char information `ga` with unicode names
Plug 'tpope/vim-characterize'
" todo manager
Plug 'davidoc/taskpaper.vim'

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
" nvim-compatibility for vim
if has('nvim')
  if g:at_work || g:work_laptop
    colorscheme NeoSolarized
  else
    colorscheme ofirkai
  endif
else
  source ~/.vim/non-nvim.vim
endif

" work-specific tooling
if g:at_work
  source $HOME/.vim/work.vim
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
set breakindentopt=shift:4

set scrolloff=4
set sidescrolloff=5

set textwidth=80

set tabstop=2
set shiftwidth=2
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

set completeopt=menu,menuone,noselect

" max line matching offset in diff mode
if has('nvim-0.9')
  silent! set diffopt+=linematch:40
endif

" global statusline to reduce visual clutter
if has('nvim-0.7')
  set laststatus=3
endif

" wildcard ignore expressions
set wildignore+=*.o,*.pyc,*.a,Session.vim,*.obj,*.make,*.cmake
set wildignore+=bin/*,build/*,*/bin/*,*/build/*

" save on losing focus
autocmd FocusLost,Tableave,BufLeave * call Autosave()
function! Autosave()
    if filereadable(expand("%:p"))
        silent! write
    endif
endfunction
if g:at_work
  function! MaybeFormatCode()
    if !&diff && codefmt#IsFormatterAvailable()
      FormatCode
    endif
  endfunction
  autocmd BufWritePre /google/* call MaybeFormatCode()
  " Use ›:noa w‹ to skip autocommand
endif

" check for external changes on gaining focus on real file
autocmd FocusGained,BufEnter */* checktime


" ===== LANGUAGE SERVER CONFIG =====
if has('nvim')
  let g:coq_settings = {
              \ 'display.icons.mode': 'none',
              \ 'completion.always': v:false,
              \ 'keymap.jump_to_mark': '<LocalLeader>m',
              \ }

  if g:at_work
    luafile $HOME/.vim/lua/coq_ciderlsp.lua
    " TODO if nothing works for ml suggest, how about coc.nvim? it's more like
    " ale in the config, so that's annoying.
    " luafile $HOME/.vim/lua/cmp_ciderlsp.lua
    " TODO enable
    " luafile $HOME/.vim/lua/diagnostics.lua
  else
    " TODO Configure language servers / linters for home use
  endif
endif


" ===== PLUGIN CONFIG =====

call lengthmatters#highlight_link_to('FoldColumn')

let g:task_paper_search_hide_done = 1

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
endfunction
" don't display branch marker for 'dirty'
let g:airline#extensions#branch#vcs_checks = ['untracked']
" don't display filetype at all
let g:airline_section_x = ''
" show file line count in position section
let g:airline_section_z =
      \ '%p%% ' .
      \ '%l%#__accent_bold#/%L%#__restore__#' .
      \ ':%3v'
let g:airline#extensions#tabline#enabled = 0
