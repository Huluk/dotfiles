if not (vim.g.at_work > 0) then return {} end

local function goog(plugin, config)
  return {
    name = plugin,
    dir = "/usr/share/vim/google/" .. plugin,
    dependencies = { "maktaba" },
    config = config,
  }
end
-- TODO https://paste.googleplex.com/5669657791954944#l=16

return {
  -- mercurial wrapper
  "ludovicchabant/vim-lawrencium",
  -- codesearch integration
  {
    url = "sso://user/vintharas/telescope-codesearch.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  -- cmp-nvim-ciderlsp
  {
    url = "sso://user/piloto/cmp-nvim-ciderlsp",
    config = function()
      require('lspconfig.configs').ciderlsp = {
        default_config = require('server/ciderlsp')
      }
    end,
  },
}
