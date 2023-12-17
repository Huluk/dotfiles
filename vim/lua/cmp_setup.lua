local lsp_config = require('lsp_config')
local cmp = require("cmp")

local M = {}

function M.setup(servers)
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<Esc>"] = cmp.mapping.close(),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback() -- vim-endwise
        end
      end,
    }),

    sources = {
      { name = "nvim_lsp" },
      -- { name = "path" }, -- requires 'cmp-path'
      { name = "vim_vsnip" }, -- requires 'cmp-vsnip'
      { name = "buffer",   keyword_length = 5 },
    },

    sorting = {
      comparators = {}, -- We stop all sorting to let the lsp do the sorting
    },

    completion = {
      autocomplete = false,
    },

    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },

    experimental = {
      native_menu = false,
      ghost_text = false,
    },
  })


  vim.cmd([[
    augroup CmpZsh
      au!
      autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
    augroup END
  ]])

  local capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  for _, server in ipairs(servers) do
    lsp_config.setup(server, {
      on_attach = lsp_config.attach,
      capabilities = capabilities,
      settings = lsp_config.settings(server),
    })
  end
end

return M
