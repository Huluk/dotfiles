let b:commentary_format = '// %s'

au BufWritePre * lua vim.lsp.buf.format()
