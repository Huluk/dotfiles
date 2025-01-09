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
