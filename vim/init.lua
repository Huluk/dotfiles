-- ===== WORK SETUP =====
local at_work = vim.fn.isdirectory('/google') ~= 0
local macunix = vim.fn.has('macunix') ~= 0
vim.g.at_work = at_work and not macunix and 1 or 0
vim.g.work_laptop = at_work and macunix and 1 or 0

-- Need to be set before loading lazy plugins.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require('config.compatibility')
require('config.lazy')

vim.cmd([[source ~/.vimrc]])
require('config.util')

if vim.g.at_work > 0 then
  vim.cmd([[source $HOME/.vim/work.vim]])
  require('work')
  -- fix expand not showing a relative path
  vim.cmd([[lcd .]])
end

if vim.g.at_work > 0 then
  vim.g.lsp_servers = { 'ciderlsp', 'lua_ls' }
elseif vim.g.work_laptop > 0 then
  vim.g.lsp_servers = {}
else
  vim.g.lsp_servers = { 'dartls', 'lua_ls' }
end

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end
