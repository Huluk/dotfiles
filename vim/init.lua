require('config.compatibility')
require('config.util')
vim.cmd([[source ~/.vimrc]])
require('config.statusline') -- side-effect: sets vim.o.statusline

require('config.lazy')

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

vim.g.lsp_servers = { 'dartls', 'lua_ls', 'serverpod' }

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end

vim.opt.runtimepath:prepend('~/.vim')
