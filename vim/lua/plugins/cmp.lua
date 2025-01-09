vim.g.lsp = 'cmp'

return {
  -- language server
  "neovim/nvim-lspconfig",
  -- Buffer-based completion
  "hrsh7th/cmp-buffer",
  -- LSP-based completion
  "hrsh7th/cmp-nvim-lsp",
  -- Snippet engine
  "hrsh7th/cmp-vsnip",
  -- Lua api completion
  "hrsh7th/cmp-nvim-lua",
  -- Main completion engine
  "hrsh7th/nvim-cmp",
  -- Snippet engine, part 2
  "hrsh7th/vim-vsnip",
}
