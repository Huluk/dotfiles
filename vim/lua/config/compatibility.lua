-- Support clipboard over ssh via tmux, for older nvim versions.
if not vim.fn.has('nvim-0.10') then
  require('clipboard')
end

-- Max line matching offset in diff mode.
if vim.fn.has('nvim-0.9') then
  vim.opt.diffopt:append('linematch:40')
end
