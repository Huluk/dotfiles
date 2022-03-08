-- Works for work setup (g:at_work) only

local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')

configs.ciderlsp = {
  default_config = {
    cmd = {'/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'c', 'cpp', 'java', 'proto', 'textproto', 'go', 'python', 'bzl'};
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

  local map = function(key, value)
    vim.api.nvim_buf_set_keymap(bufnr,"n",key,value,{noremap = true, silent = true});
  end

  -- Omni-completion via LSP. See `:help compl-omni`. Use <C-x><C-o> in
  -- insert mode. Or use an external autocompleter (see below) for a
  -- smoother UX.
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if vim.lsp.formatexpr then -- Neovim v0.6.0+ only.
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr")
  end
  if vim.lsp.tagfunc then -- Neovim v0.6.0+ only.
      -- Tag functionality via LSP. See `:help tag-commands`. Use <c-]> to
      -- go-to-definition.
      vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
  end

  -- info
  map('γ','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('<S-k>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('φ','<cmd>lua vim.lsp.buf.references()<CR>')
  -- does not work
  map('π','<cmd>lua peek("textDocument/implementation")<CR>')
  map('gπ','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('ι','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('ο','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- modify
  map('ρ','<cmd>lua vim.lsp.buf.rename()<CR>')
  -- TODO deprecating f, use x
  map('<leader>f','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('<leader>x','<cmd>lua vim.lsp.buf.code_action()<CR>')

  -- full document
  map('<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('<localleader>υ','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('<localleader>ω','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  -- diagnostic
  map('(','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  map(')','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('<leader>d','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('<leader>D','<cmd>lua vim.lsp.diagnostic.get_all()<CR>')

  vim.api.nvim_command("augroup LSP")
  vim.api.nvim_command("autocmd!")
  if client.resolved_capabilities.document_highlight then
      vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
  end
  vim.api.nvim_command("augroup END")
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

nvim_lsp.ciderlsp.setup{ on_attach = custom_attach }
