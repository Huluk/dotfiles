syn match pomoAll   "\v---? (\d+\.?\d?\/)?\d+(\.\d)?$"
syn match pomoZero  "\v---? (\d+\.?\d?\/)?(0\.?0?|\?+)$"
syn match pomoHalf  "\v---? (\d\.?\d?\/)?0?\.[1-9]$"
syn match pomoOne   "\v---? (\d\.?\d?\/)?1(\.\d)?$"
syn match pomoTwo   "\v---? (\d\.?\d?\/)?2(\.\d)?$"
syn match pomoThree "\v---? (\d\.?\d?\/)?3(\.\d)?$"
syn match pomoFour  "\v---? (\d\.?\d?\/)?4(\.\d)?$"

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
" black
hi pomoZero ctermbg=0 ctermfg=7
