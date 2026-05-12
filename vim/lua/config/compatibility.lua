-- Returns true if the running Neovim is at least version `major.minor`.
local function has(major, minor)
  return vim.fn.has('nvim-' .. major .. '.' .. minor) == 1
end

-- Support clipboard over ssh via tmux, for older nvim versions.
if not has(0, 10) then
  require('clipboard')
end

-- Max line matching offset in diff mode.
if has(0, 9) then
  vim.opt.diffopt:append('linematch:40')
end

-- Global statusline to reduce visual clutter.
if has(0, 7) then
  vim.opt.laststatus = 3
end
