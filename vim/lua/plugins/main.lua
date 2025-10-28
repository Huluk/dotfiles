return {
  -- === Optics ===
  -- themes
  {
    "ofirgall/ofirkai.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme ofirkai]]
      require('ofirkai').setup {
        custom_hlgroups = {
          -- These overrides are flaky :(
          -- TabLineSel = { fg = "#f20aee", bg = "#343942" },
          -- TabLine = { fg = "#78b6e8", bg = "#343942" },
        },
      }
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme solarized-osaka]]
    end,
  },

  -- === Core Extensions ===
  -- Language-based syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        indent = {
          ensure_installed = { "lua", "vim", "markdown" },
          sync_install = true,
          auto_install = false,
          ignore_install = {},
          enable = true,
          disable = { "markdown" },
        }
      })
    end,
  },
  -- Lua utils, dependency of telescope and others.
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  -- Fuzzyfinder
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  -- Fast fzf sorting
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'make',
    config = function()
      require('telescope').setup {}
      require('telescope').load_extension('fzf')
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  -- Frequent/recent file open
  {
    enabled = false, -- Needs nvim > 0.10
    "nvim-telescope/telescope-frecency.nvim",
    version = "*",
    config = function()
      require('telescope').load_extension('frecency')
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- === Editing ===
  -- make `.` work with tpope's plugins
  "tpope/vim-repeat",
  -- surround words and other units with parens, quotes etc.
  "tpope/vim-surround",
  -- comment stuff out with gcc, gc etc.
  "tpope/vim-commentary",
  -- increment/decrement dates/times etc, same as normal numbers
  "tpope/vim-speeddating",
  -- auto-add end statements of indented code blocks
  { "tpope/vim-endwise", ft = { "ruby", "lua" } },
  -- tree structure for undo/redo operations
  "mbbill/undotree",
  -- automatically leave insert mode after inactivity
  {
    "csessh/stopinsert.nvim",
    enabled = false,
    opts = {
      idle_time_ms = 180000, -- 3 minutes
    },
  },

  -- === Highlighting ===
  -- highlight text outside of textwidth
  {
    "whatyouhide/vim-lengthmatters",
    config = function()
      vim.fn["lengthmatters#highlight_link_to"]("FoldColumn")
    end,
  },
  -- auto-remove search highlight on cursor movement
  "junegunn/vim-slash",
  -- auto-disable highlight after some time
  {
    -- Note: Temporary using fork to circumvent search error (issue #2)
    -- "sahlte/timed-highlight.nvim"
    "senilio/timed-highlight.nvim",
    opts = {
      highlight_timeout_ms = 3500
    },
  },

  -- === Integration ===
  -- git wrapper
  "tpope/vim-fugitive",
  -- jj wrapper
  {
    "NicolasGB/jj.nvim",
    opts = {},
  },
  "rafikdraoui/jj-diffconflicts",
  -- fix tmux focus integration
  "tmux-plugins/vim-tmux-focus-events",
  -- tmux split navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- tmux remote clipboard
  {
    "ojroques/nvim-osc52",
    cond = function()
      return vim.fn.has "nvim-0.10" == 0
    end,
  },
  -- open at line number after colon
  "wsdjeg/vim-fetch",
  -- jump to last line on file open
  "farmergreg/vim-lastplace",

  -- === Other ===
  -- extend char information `ga` with unicode names
  "tpope/vim-characterize",
  -- hotkey tooling, needs plenary
  {
    "tris203/hawtkeys.nvim",
    opts = {},
  },

  -- === Dev ===
  "dstein64/vim-startuptime",
  -- exreader
  {
    enabled = false,
    "~/Documents/exreader",
    cond = function()
      return vim.fn.isdirectory(vim.env.HOME .. "/Documents/exreader") == 1
    end,
  },
}
