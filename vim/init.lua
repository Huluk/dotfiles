require('config.compatibility')
require('config.util')
vim.cmd([[source ~/.vimrc]])

require('config.lazy')

vim.g.lsp_servers = { 'dartls', 'lua_ls' }

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end

vim.opt.runtimepath:prepend('~/.vim')
