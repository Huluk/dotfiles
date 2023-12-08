local nvim_lsp = require("lspconfig")
local configs = require("lspconfig.configs")

configs.ciderlsp = {
  default_config = {
    cmd = {
        '/google/bin/releases/cider/ciderlsp/ciderlsp',
        '--tooltag=nvim-lsp',
        '--noforward_sync_responses',
    };
    filetypes = {
        'c',
        'cpp',
        'java',
        'kotlin',
        'objc',
        'proto',
        'textproto',
        'go',
        'python',
        'bzl'
    };
    root_dir = nvim_lsp.util.root_pattern('BUILD');
    settings = {};
  };
}
