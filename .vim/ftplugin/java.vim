:set cinoptions+=j1
:let java_comment_strings=1
:let java_highlight_java_lang_ids=1
:let java_mark_braces_in_parens_as_errors=1
:let java_highlight_all=1
:let java_highlight_functions="style"
:let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
"compile on S-A-b (make bin)"
:map β :w<CR>:Javac<CR>
"run on S-A-r"
:map ρ :Java<CR>
"comment and uncomment (ctrl-k and shift-alt-k)
:map <C-k> :s/^\(\s*\)/\1\/\/ /<CR>
:map κ :s/^\(\s*\)\/\/ \?/\1/<CR>
