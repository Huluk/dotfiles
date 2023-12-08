local nvim_lsp = require('lspconfig')
local lsp_config = require('lsp_config')
local coq = require('coq')

local M = {}

function M.setup(servers)
  for i,server in ipairs(servers) do
    lsp_config.setup(server, coq.lsp_ensure_capabilities{
      on_attach = lsp_config.attach
    })
  end

  vim.api.nvim_command('COQnow -s')
end

return M
