-- Works for work setup (g:at_work) only

local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')
local coq = require('coq')

configs.ciderlsp = {
  default_config = {
    cmd = {'/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'c', 'cpp', 'java', 'kotlin', 'objc', 'proto', 'textproto', 'go', 'python', 'bzl'};
    root_dir = nvim_lsp.util.root_pattern('BUILD');
    settings = {};
  };
}

require('lsp_config')
nvim_lsp.ciderlsp.setup{ on_attach = custom_attach }

nvim_lsp.ciderlsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

nvim_lsp.ciderlsp.setup(coq.lsp_ensure_capabilities{ on_attach = custom_attach })
vim.api.nvim_command('COQnow -s')
