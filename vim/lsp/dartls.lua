local util = require('lspconfig.util')

---@type vim.lsp.Config
return {
  filetypes = { 'dart' },
  -- root_dir = function(bufnr, on_dir)
  --   local fname = vim.api.nvim_buf_get_name(bufnr)
  --   if string.match(fname, "^fugitive://") then
  --     return
  --   end
  --   on_dir(util.root_pattern('pubspec.yaml')(fname))
  -- end,
  root_markers = { 'pubspec.yaml' },
  init_options = {
    allowAnalytics = false,
    closingLabels = false,
    devToolsBrowser = 'default',
    enableSnippets = false,
    showTodos = false,
  }
}
