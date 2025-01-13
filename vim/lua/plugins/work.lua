if not (vim.g.at_work > 0) then return {} end

local function goog(args)
  if args.name == nil then
    args.name = args[1]
    args[1] = nil
  end
  if args.dir == nil then
    args.dir = "/usr/share/vim/google/" .. args.name
  end
  if args.dependencies == nil then
    args.dependencies = {'maktaba'}
  else
    table.insert(args.dependencies, 'maktaba')
  end
  return args
end

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
  
  -- INTERNAL PLUGINS
  -- loader
  {
    name = "maktaba",
    dir = "/usr/share/vim/google/maktaba",
    init = function ()
      vim.cmd("source /usr/share/vim/google/glug/bootstrap.vim")
    end,
  },
  -- default
  goog{'logmsgs'},
  goog{'glaive'},
  goog{'compatibility'},
  goog{'googler'},
  goog{'google-filetypes'},
  goog{'ft-cpp', ft = {'cpp'}},
  goog{'ft-go', ft = {'go'}},
  goog{'ft-java', ft = {'java'}},
  goog{'ft-javascript', ft = {'javascript'}},
  goog{'ft-kotlin', ft = {'kotlin'}},
  goog{'ft-proto'},
  goog{'ft-python', ft = {'python'}},
  goog{'ft-soy', ft = {'soy'}},
  goog{'autogen'},
  -- goog{'clang-format', ft = {'cpp'}},
  goog{'codefmt'},
  goog{'codefmt-google'},
  goog{'critique'},
  goog{'googlepaths'},
  goog{'googlestyle'},
  goog{'googlespell'},
  goog{'piper'},
  goog{
    'relatedfiles',
    dependencies = {'glaive'},
    config = function()
      vim.cmd("Glaive relatedfiles !plugin[mappings]")
    end,
  },
  goog{
    'safetmpdirs',
    dependencies = {'glaive'},
    config = function()
      vim.cmd([=[Glaive safetmpdirs unsafe_patterns=`['\m^/google/src/cloud/','\m^/google/data/']`]=])
    end
  },
  -- custom
  -- open in code search
  goog{
    'corpweb',
    enabled = false, -- Does not work via ssh.
    dependencies = {'glaive'},
    config = function()
      vim.cmd("Glaive corpweb !plugin[mappings_gx]")
    end,
    keys = {
      -- open current position in code search
      { "<leader>wo", "<cmd>CorpWebCsFile<CR>" },
      -- open cl in critique
      { "leader>cl", "<cmd>CorpWebCritiqueCl<CR>" },
      -- nnoremap <leader>ws :call corpweb#CodeSearchLiteral(expand("<cword>"))<CR>
      -- vnoremap <leader>ws :<C-U>call corpweb#CodeSearchLiteral(maktaba#buffer#GetVisualSelection())<CR>
    },
  },
  goog{'google-csimporter'}, -- java imports
}
