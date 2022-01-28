-- Works for work setup (g:at_work) only

local nvim_lsp = require'lspconfig'
local configs = require'lspconfig/configs'

configs.ciderlsp = {
  default_config = {
    cmd = {'/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    -- TODO re-add 'c', 'cpp' once ycm is removed
    filetypes = {'java', 'proto', 'textproto', 'go', 'python', 'bzl'};
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

local custom_attach = function(client, bufnr)
  print("LSP started.");

  local map = function(type, key, value)
    vim.api.nvim_buf_set_keymap(bufnr,type,key,value,{noremap = true, silent = true});
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- info
  map('n','γ','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','<S-k>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','φ','<cmd>lua vim.lsp.buf.references()<CR>')
  -- does not work
  map('n','π','<cmd>lua peek("textDocument/implementation")<CR>')
  map('n','gπ','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','ι','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','ο','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- modify
  map('n','ρ','<cmd>lua vim.lsp.buf.rename()<CR>')
  -- TODO deprecating f, use x
  map('n','<leader>f','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>x','<cmd>lua vim.lsp.buf.code_action()<CR>')

  -- full document
  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<localleader>υ','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<localleader>ω','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  -- diagnostic
  map('n','(','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  map('n',')','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n','<leader>d','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n','<leader>D','<cmd>lua vim.lsp.diagnostic.get_all()<CR>')
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

nvim_lsp.ciderlsp.setup{ on_attach = custom_attach }
