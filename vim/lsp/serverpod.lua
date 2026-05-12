---@type vim.lsp.Config
return {
  cmd = { 'serverpod', 'language-server' },
  filetypes = { 'yaml' },
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path:find('models/.*%.ya?ml$') then
      on_dir(vim.fs.root(bufnr, 'pubspec.yaml'));
    end
  end,
}
