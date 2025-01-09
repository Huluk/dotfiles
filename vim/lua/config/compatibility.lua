local nvim_version = vim.version()

-- Support clipboard over ssh via tmux, for older nvim versions.
if nvim_version.major < 1 and nvim_version.minor < 10 then
  require('clipboard')
end

-- Max line matching offset in diff mode.
-- Hawtkeys plugin to suggest unmapped hotkeys.
if nvim_version.major >= 1 or nvim_version.minor >= 9 then
  vim.opt.diffopt:append('linematch:40')
end

-- Global statusline to reduce visual clutter.
if nvim_version.major >= 1 or nvim_version.minor >= 7 then
  vim.opt.laststatus = 3
end
