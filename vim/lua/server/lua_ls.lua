local opt = {}

opt.settings = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using
      -- (most likely LuaJIT in the case of Neovim)
      version = "LuaJIT",
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {
        "vim",
      },
    },
    -- Make the server aware of Neovim runtime files
    workspace = {
      checkThirdParty = false,
      library = {
        vim.env.VIMRUNTIME,
        -- "${3rd}/luv/library",
        -- "${3rd}/busted/library",
      },
    },
    telemetry = {
      enable = false,
    },
  },
}

return opt
