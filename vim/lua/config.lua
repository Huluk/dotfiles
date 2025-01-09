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
