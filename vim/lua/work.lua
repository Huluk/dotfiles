local cs = require('telescope').extensions.codesearch

function inNewTab(f)
  return function()
    vim.cmd('tabnew')
    f()
  end
end

function relatedTestFile(path)
  -- Remove path prefix, if needed.
  path = path:gsub(".*google3/", "", 1)
  if path:match(".*_test$") ~= nil then
    return path
  end
  return path .. '_test'
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

-- Run for current file
-- tests
vim.keymap.set("n", "<localleader>rt", function()
    TmuxExecuteR("blaze test " .. relatedTestFile(vim.fn.expand("%:r")))
  end, { noremap = true, silent = true })
-- build
vim.keymap.set("n", "<localleader>rb", function()
    TmuxExecuteR("blaze build " .. vim.fn.expand("%:r"))
  end, { noremap = true, silent = true })
