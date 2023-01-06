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

local preview_location_callback = function(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

peek = function(f)
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, f, params, preview_location_callback)
end

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
