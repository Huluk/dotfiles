local cs = require('telescope').extensions.codesearch

function inNewTab(f)
  return function()
    vim.cmd('tabnew')
    f()
  end
end

function relatedFile(selector)
  local current_file = vim.fn.expand('%:p')
  local related_files = vim.fn['relatedfiles#GetFiles'](current_file)[selector]
  if #related_files == 0 then
    return current_file
  end
  return related_files[1]
end

function toBlazeTarget(path)
  return vim.fn.fnamemodify(path, ":r"):gsub(".*google3/", "", 1)
end

-- CodeSearch telescope search and CodeSearch web search
-- search for file (path)
vim.keymap.set("n", "<leader>p", cs.find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>P", inNewTab(cs.find_files), { noremap = true, silent = true })
-- search for text (query)
vim.keymap.set("n", "<leader>f", cs.find_query, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>F", inNewTab(cs.find_query), { noremap = true, silent = true })
-- search for word under cursor
vim.keymap.set("n", "<leader>cs", function()
    cs.find_query{default_text_expand='<cword>'}
  end, { noremap = true, silent = true })

-- Open related files
vim.keymap.set("n", "<localleader>c", function()
  vim.api.nvim_command("edit " .. relatedFile('c'))
end)
vim.keymap.set("n", "<localleader>C", function()
  vim.api.nvim_command("tabedit " .. relatedFile('c'))
end)
vim.keymap.set("n", "<localleader>h", function()
  vim.api.nvim_command("edit " .. relatedFile('h'))
end)
vim.keymap.set("n", "<localleader>H", function()
  vim.api.nvim_command("tabedit " .. relatedFile('h'))
end)
vim.keymap.set("n", "<localleader>t", function()
  vim.api.nvim_command("edit " .. relatedFile('t'))
end)
vim.keymap.set("n", "<localleader>T", function()
  vim.api.nvim_command("tabedit " .. relatedFile('t'))
end)
vim.keymap.set("n", "<localleader>b", function()
  vim.api.nvim_command("edit " .. relatedFile('b'))
end)
vim.keymap.set("n", "<localleader>B", function()
  vim.api.nvim_command("tabedit " .. relatedFile('b'))
end)

-- Run for current file
-- tests
vim.keymap.set("n", "<localleader>rt", function()
    TmuxExecuteR("blaze test " .. toBlazeTarget(relatedFile('t')))
  end, { noremap = true, silent = true })
-- build
vim.keymap.set("n", "<localleader>rb", function()
    TmuxExecuteR("blaze build " .. toBlazeTarget(relatedFile('c')))
  end, { noremap = true, silent = true })
