:setlocal expandtab
:setlocal softtabstop=2
:setlocal shiftwidth=2
"run current file (ρ is shift-alt-r in neo layout"
:map ρ :w<CR>:!ruby %:gs? ?\\ ?<CR>
"run current file in rspec (σ is shift-alt-r in neo layout"
:map σ :w<CR>:!rspec %:gs? ?\\ ?<CR>
