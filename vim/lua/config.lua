local nvim_version = vim.version()

-- Support clipboard over ssh via tmux, for older nvim versions.
if nvim_version.major < 1 and nvim_version.minor < 10 then
  require('clipboard')
end

-- Max line matching offset in diff mode.
-- Hawtkeys plugin to suggest unmapped hotkeys.
if nvim_version.major >= 1 or nvim_version.minor >= 9 then
  vim.opt.diffopt:append('linematch:40')

  require('hawtkeys').setup({})
end

-- Global statusline to reduce visual clutter.
if nvim_version.major >= 1 or nvim_version.minor >= 7 then
  vim.opt.laststatus = 3
end

require('timed-highlight').setup({ highlight_timeout_ms = 3500 })

local theme = {
  fill = 'TabLineFill',
  head = 'TabLineFill',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}
function home_path()
  return vim.fn.getcwd()
    :gsub('^' .. vim.env.HOME, '~', 1)
    :gsub("^/google.*/([^/]+)/google3", "☿/%1/g3", 1)
end
require('tabby').setup({
  line = function(line)
    local current_tab =
      line.tabs().filter(function(tab) return tab.is_current() end).tabs[1]
    return {
      {
        { current_tab.close_btn('X'), hl = theme.head },
        line.sep(' ', theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        local windows = line.wins()
        return {
          #windows > 1 and #windows or '',
          tab.name(),
          line.sep('', hl, theme.fill),
          hl = hl,
          margin = ' ',
        }
      end),
      line.spacer(),
      { home_path(), hl = theme.tail },
      hl = theme.fill,
    }
  end,
})

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
