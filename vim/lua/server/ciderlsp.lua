local opt = {}

opt.cmd = {
  '/google/bin/releases/cider/ciderlsp/ciderlsp',
  '--tooltag=nvim-lsp',
  '--noforward_sync_responses',
}

opt.filetypes = {
  'c',
  'cpp',
  'java',
  'kotlin',
  'objc',
  'proto',
  'textproto',
  'go',
  'python',
  'bzl',
}

opt.root_dir = require('lspconfig').util.root_pattern('BUILD')

opt.settings = {}

return opt
