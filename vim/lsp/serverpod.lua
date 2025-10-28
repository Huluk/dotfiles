---@type vim.lsp.Config
return {
  cmd = { 'serverpod', 'language-server' },
  filetypes = { 'yaml', 'yml' },
  root_markers = { 'pubspec.yaml' },
}
