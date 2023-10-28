local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')
local coq = require('coq')

require('lsp_config')

nvim_lsp.dartls.setup(coq.lsp_ensure_capabilities{ on_attach = custom_attach })

nvim_lsp.dartls.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

vim.api.nvim_command('COQnow -s')
