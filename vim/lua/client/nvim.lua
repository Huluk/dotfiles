local M = {}

function M.ensure_capabilities(_, opts)
  return opts
end

function M.post(_)
  vim.api.nvim_buf_set_keymap(0, 'i', '<C-Space>',
    '<cmd>lua vim.lsp.omnifunc()<CR>',
    { noremap = true, silent = true }
  );
end

return M
