local nvim_version = vim.version()

-- Support clipboard over ssh via tmux, for older nvim versions.
if nvim_version.major < 1 and nvim_version.minor < 10 then
  require('clipboard')
end

-- Max line matching offset in diff mode.
-- Hawtkeys plugin to suggest unmapped hotkeys.
if nvim_version.major >= 1 or nvim_version.minor >= 9 then
  vim.opt.diffopt:append('linematch:40')

  require('hawtkeys').setup{}
end

-- Global statusline to reduce visual clutter.
if nvim_version.major >= 1 or nvim_version.minor >= 7 then
  vim.opt.laststatus = 3
end

require('timed-highlight').setup{ highlight_timeout_ms = 3500 }

vim.g.barbar_auto_setup = false
require('barbar').setup{
  animation = false,
  auto_hide = 1,
  tabpages = true, -- counter in top-right corner
  focus_on_close = 'previous',

  icons = {
    -- Configure the base icons on the bufferline.
    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
    buffer_index = false,
    buffer_number = false,
    button = false,
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
      [vim.diagnostic.severity.WARN] = { enabled = false },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
    },
    gitsigns = {
      added = { enabled = false },
      changed = { enabled = false },
      deleted = { enabled = false },
    },
    filetype = { enabled = false },
    separator = { left = '', right = '' },
    inactive = { separator = { left = '', right = '' } },

    modified = { button = '' },
    pinned = { button = '', filename = true },
  },

  maximum_padding = 1,

  no_name_title = '[No Name]',
}

if vim.g.at_work > 0 then
  require('lspconfig.configs').ciderlsp = { default_config = require('server/ciderlsp') }
  vim.g.lsp_servers = { 'ciderlsp' }
elseif vim.g.work_laptop > 0 then
  vim.g.lsp_servers = {}
else
  vim.g.lsp_servers = { 'dartls', 'lua_ls' }
end

if #vim.g.lsp_servers then
  require('lsp_setup').setup(vim.g.lsp, vim.g.lsp_servers)
  -- TODO configure and enable
  -- require('diagnostics')
end

if vim.fn.executable('tmux') == 1 then
  local function is_tmux_running()
    return vim.env.TMUX ~= nil
  end

  -- Execute command in tmux pane to the right.
  function _G.TmuxExecuteR(cmd)
    if (not is_tmux_running()) then return end
    local main_pane = vim.fn.system("tmux display -p '#{pane_id}'")
    vim.fn.system("tmux selectp -R")
    local exec_pane = vim.fn.system("tmux display -p '#{pane_id}'")
    if (vim.trim(main_pane) == vim.trim(exec_pane)) then return end

    vim.fn.system("tmux send -t " .. vim.trim(exec_pane) .. " '" .. cmd .. "' C-m")

    vim.fn.system("tmux select-pane -l")
  end
end
