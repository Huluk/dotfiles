local preview_location_callback = function(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

local peek = function(f)
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, f, params, preview_location_callback)
end


custom_attach = function(client, bufnr)
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

  -- INFO
  -- hover for current word
  map('<S-k>','<cmd>lua vim.lsp.buf.hover()<CR>')
  -- jump to definition (S-A-g)
  map('γ','<cmd>lua vim.lsp.buf.definition()<CR>')
  -- display all references (S-A-r)
  map('ρ','<cmd>lua vim.lsp.buf.references()<CR>')
  -- all following are CURRENTLY NOT SUPPORTED in CiderLSP:
  -- peek implementations (S-A-h)
  map('ψ','<cmd>lua peek("textDocument/implementation")<CR>')
  -- go to implementations (g S-A-h)
  map('gψ','<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- list all callers of symbol (S-A-i)
  map('ι','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  -- list all items called by the symbol (S-A-o)
  map('ο','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- MODIFY
  -- rename
  map('<leader>r','<cmd>lua vim.lsp.buf.rename()<CR>')
  -- fix error under cursor
  map('<leader>x','<cmd>lua vim.lsp.buf.code_action()<CR>')

  -- DOCUMENT
  -- format
  map('<leader>=', '<cmd>lua vim.lsp.buf.format()<CR>')
  -- display all symbols
  map('σ','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  -- search for symbol in workspace
  map('ω','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  -- DIAGNOSTIC
  -- previous error
  map('(','<cmd>lua vim.diagnostic.goto_prev()<CR>')
  -- next error
  map(')','<cmd>lua vim.diagnostic.goto_next()<CR>')
  -- display diagnostics (S-A-d)
  map('δ','<cmd>lua vim.diagnostic.open_float()<CR>')
  -- display all errors (S-A-a)
  map('<leader>α','<cmd>lua vim.diagnostic.get_all()<CR>')

  vim.api.nvim_command("augroup LSP")
  vim.api.nvim_command("autocmd!")
  if client.resolved_capabilities.document_highlight then
      vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
  end
  vim.api.nvim_command("augroup END")

  print("LSP started.");
end