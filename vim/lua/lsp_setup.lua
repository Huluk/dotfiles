local M = {}

function M.jump_diagnostic(count)
  vim.diagnostic.jump({ count = count })
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags > 0 then
    local msg = diags[1].message:match("([^\n]+)")
    vim.api.nvim_echo({ { msg, "Normal" } }, false, {})
  end
end

function M.attach(client, bufnr)
  local map = function(key, value)
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, value, { noremap = true, silent = true });
  end

  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  -- INFO
  -- hover for current word
  map('<S-k>', '<cmd>lua vim.lsp.buf.hover()<CR>')
  -- signature help
  -- map('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- type definition
  -- map('gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  -- jump to definition (S-A-g)
  map('γ', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- jump to declaration
  map('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- display all references (S-A-r)
  map('ρ', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- all following are CURRENTLY NOT SUPPORTED in CiderLSP:
  -- peek implementations (S-A-h)
  map('ψ', '<cmd>lua peek("textDocument/implementation")<CR>')
  -- go to implementations (g S-A-h)
  map('gψ', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- list all callers of symbol (S-A-i)
  map('ι', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  -- list all items called by the symbol (S-A-o)
  map('ο', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- MODIFY
  -- rename
  map('<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- fix error under cursor
  map('<leader>x', '<cmd>lua vim.lsp.buf.code_action()<CR>')

  -- DOCUMENT
  -- format
  map('<leader>=', '<cmd>lua vim.lsp.buf.format()<CR>')
  -- display all symbols
  map('σ', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  -- search for symbol in workspace
  map('ω', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  -- DIAGNOSTIC
  -- previous error
  map('(', '<cmd>lua require("lsp_setup").jump_diagnostic(-1)<CR>')
  -- next error
  map(')', '<cmd>lua require("lsp_setup").jump_diagnostic(1)<CR>')
  -- display diagnostics (S-A-d)
  map('δ', '<cmd>lua vim.diagnostic.open_float()<CR>')
  -- display all errors (S-A-a)
  map('<leader>α', '<cmd>lua vim.diagnostic.get_all()<CR>')

  -- Per-buffer augroup so attaching LSP to one buffer doesn't wipe autocmds
  -- on another buffer.
  local group = vim.api.nvim_create_augroup('LSP_' .. bufnr, { clear = true })
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = group,
      buffer = bufnr,
      callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = bufnr,
      callback = function() vim.lsp.util.buf_clear_references() end,
    })
  end
  if client.server_capabilities.documentFormattingProvider then
    -- Use ›:noa w‹ to skip autocommand
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = group,
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end,
    })
  end

  print("LSP started.");
end

function M.old_setup(client_name, servers)
  local nvim_lsp = require('lspconfig')

  local client = require('client/' .. client_name)
  if client.pre then client.pre(servers) else end
  for _, server in ipairs(servers) do
    local optsfile = 'server/' .. server
    local status, opts = pcall(require, optsfile)
    if not status then opts = {} end
    opts.on_attach = M.attach
    nvim_lsp[server].setup(client.ensure_capabilities(server, opts))
  end
  if client.post then client.post(servers) else end
end

function M.new_setup(client_name, servers)
  local client = require('client/' .. client_name)
  if client.pre then client.pre(servers) else end
  vim.lsp.config('*', {
    capabilities = client.capabilities,
    on_attach = M.attach,
  })
  vim.lsp.enable(servers)
end

function M.setup(client_name, servers)
  local nvim_version = vim.version()

  if nvim_version.major < 1 and nvim_version.minor <= 10 then
    M.old_setup(client_name, servers)
  else
    M.new_setup(client_name, servers)
  end
end

return M
