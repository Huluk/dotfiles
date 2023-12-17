local lsp_config = require('lsp_config')

local M = {}

function M.setup(servers)
  for _, server in ipairs(servers) do
    lsp_config.setup(server, {
      on_attach = lsp_config.attach,
      settings = lsp_config.settings(server),
    })
  end

  vim.api.nvim_buf_set_keymap(0, 'i', '<C-Space>',
    '<cmd>lua vim.lsp.omnifunc()<CR>',
    { noremap = true, silent = true }
  );
end

return M
