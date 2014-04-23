syn match pomoAll "\v---? (\d+\.?5?\/)?\d+$"
syn match pomoHalf   "---\? \.5$"
syn match pomoOne   "\v---? (\d\.?5?\/)?1$"
syn match pomoTwo   "\v---? (\d\.?5?\/)?2$"
syn match pomoThree "\v---? (\d\.?5?\/)?3$"
syn match pomoFour  "\v---? (\d\.?5?\/)?4$"

" blue
hi pomoOne ctermbg=4 ctermfg=8
" cyan
hi pomoTwo ctermbg=6 ctermfg=8
" green
hi pomoThree ctermbg=2 ctermfg=8
" yellow
hi pomoFour ctermbg=3 ctermfg=8
" orange
hi pomoAll ctermbg=9 ctermfg=8
" purple
hi pomoHalf ctermbg=13 ctermfg=8
