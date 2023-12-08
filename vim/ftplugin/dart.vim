let b:commentary_format = '// %s'

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
