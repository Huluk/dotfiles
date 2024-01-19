local nvim_version = vim.version()

-- Support clipboard over ssh via tmux, for older nvim versions.
if nvim_version.major < 1 and nvim_version.minor < 10 then
  require('clipboard')
end

-- Max line matching offset in diff mode.
if nvim_version.major >= 1 or nvim_version.minor >= 9 then
  vim.opt.diffopt:append('linematch:40')
end

-- Global statusline to reduce visual clutter.
if nvim_version.major >= 1 or nvim_version.minor >= 7 then
  vim.opt.laststatus = 3
end

require("timed-highlight").setup({ highlight_timeout_ms = 3500 })

require('hawtkeys').setup({})

if vim.g.at_work > 0 then
  require('lspconfig.configs').ciderlsp = { default_config = require('server/ciderlsp') }
  vim.g.lsp_servers = {'ciderlsp'}
elseif vim.g.work_laptop > 0 then
  vim.g.lsp_servers = {'dartls', 'lua_ls'}
else
  vim.g.lsp_servers = {}
end

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end
