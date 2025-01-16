-- ===== WORK SETUP =====
local at_work = vim.fn.isdirectory('/google') ~= 0
local macunix = vim.fn.has('macunix') ~= 0
vim.g.at_work = at_work and not macunix and 1 or 0
vim.g.work_laptop = at_work and macunix and 1 or 0

require('config.compatibility')
require('config.util')
vim.cmd([[source ~/.vimrc]])

require('config.lazy')

if vim.g.at_work > 0 then
  require('config.work')
end

if vim.g.at_work > 0 then
  vim.g.lsp_servers = { 'ciderlsp' }
elseif vim.g.work_laptop > 0 then
  vim.g.lsp_servers = { 'lua_ls' }
else
  vim.g.lsp_servers = { 'dartls', 'lua_ls' }
end

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end

vim.opt.runtimepath:prepend('~/.vim')
