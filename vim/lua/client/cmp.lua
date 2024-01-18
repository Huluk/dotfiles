local cmp = require("cmp")

local M = {}

function M.pre(_)
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
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          })
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
      comparators = {
        function(entry1, entry2)
          local is_ciderlsp1 = entry1.source.name == 'nvim_ciderlsp'
          local is_ciderlsp2 = entry2.source.name == 'nvim_ciderlsp'
          if is_ciderlsp1 == is_ciderlsp2 then
            return nil
          else
            return is_ciderlsp1
          end
        end,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }
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
end

M.capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

function M.ensure_capabilities(_, opts)
  opts.capabilities = M.capabilities
  return opts
end

return M
