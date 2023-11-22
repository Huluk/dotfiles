let b:commentary_format = '// %s'

au BufWritePre <buffer> lua vim.lsp.buf.format()
